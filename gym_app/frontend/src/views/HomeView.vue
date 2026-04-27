<script>
import { TrainerService } from "@/services/trainer.service";
import { SessionManager } from "@/utils/session.manager";
import { UserService } from "@/services/user.service";

export default {
  data() {
    return {
      trainers: [],
      selectedTrainers: [],
      selectedTimeSlot: {},
      selectedTrainersWithTimeSlot: [],
      activeTrainer: null,
    };
  },
  async created() {
    await this.fetchTrainers();
    await this.fetchSelectedTrainers();
    if (!SessionManager.hasAuth()) {
      this.$router.push("/login");
    }
  },
  methods: {
    async fetchTrainers() {
      try {
        const response = await TrainerService.getAllTrainers();
        this.trainers = response.data;
      } catch (error) {
        console.error("Failed to fetch trainers:", error);
      }
    },
    async fetchSelectedTrainers() {
      try {
        if (!SessionManager.hasAuth()) return;
        const user = await UserService.getUserProfile();
        const userId = user.data.id;
        const response = await TrainerService.getSelectedTrainers(userId);
        const trainers = response.data;
        const trainerIds = trainers.map(trainer => trainer.trainer_id);
        const timeSlots = trainers.map(trainer => trainer.timeSlot_id);
        const selectedTimeSlot = [];
        for (const timeslot of timeSlots) {
          const timeSlot = await TrainerService.getTimeSlots(timeslot);
          selectedTimeSlot.push(timeSlot.data);
        }
        const selectedTrainers = [];
        for (const trainerId of trainerIds) {
          const trainer = await TrainerService.getTrainerById(trainerId);
          selectedTrainers.push(trainer.data);
        }
        this.selectedTrainers = selectedTrainers;
        this.selectedTimeSlot = selectedTimeSlot;
        this.selectedTrainersWithTimeSlot = selectedTrainers.map((trainer, index) => ({
          ...trainer,
          timeSlot: selectedTimeSlot[index]
        }));
      } catch (error) {
        console.error("Failed to fetch selected trainers:", error);
      }
    },
    isTrainerSelected(trainerId) {
      return this.selectedTrainers.some(trainer => trainer.id === trainerId);
    },
    async selectTrainer(trainerId, timeSlotId) {
      const user = await UserService.getUserProfile();
      try {
        await TrainerService.pickTrainer(trainerId, user.data.id, timeSlotId);
        await this.fetchSelectedTrainers();
      } catch (error) {
        console.error("Failed to select trainer:", error);
      }
    },
    async removeTrainer(trainerId) {
      const user = await UserService.getUserProfile();
      try {
        await TrainerService.unpickTrainer(trainerId, user.data.id);
        await this.fetchSelectedTrainers();
      } catch (error) {
        console.error("Failed to remove trainer:", error);
      }
    },
    openTrainer(trainer) {
      this.activeTrainer = trainer;
      document.body.style.overflow = 'hidden';
    },
    closeTrainer() {
      this.activeTrainer = null;
      document.body.style.overflow = '';
    }
  },
  computed: {
    availableTrainers() {
      return this.trainers.filter(trainer => !this.isTrainerSelected(trainer.id));
    }
  }
};
</script>

<template>
  <div class="container mt-5">
    <div class="row">
      <!-- Available Trainers -->
      <div class="col-md-7">
        <h1 class="mb-2">Available Trainers for personal training</h1>
        <div class="row row-cols-2 g-2">
          <div v-for="trainer in availableTrainers" :key="trainer.id" class="col mb-4">
            <div class="card profile-card" @click="openTrainer(trainer)">
              <div class="card-body">
                <h5 class="card-title">{{ trainer.name }}</h5>
                <p class="card-text">{{ trainer.speciality }}</p>
                <ul class="list-group list-group-flush">
                  <li class="list-group-item" @click.stop>
                    <label class="form-label">Select Time Slot</label>
                    <select v-model="selectedTimeSlot[trainer.id]" class="form-select">
                      <option v-for="timeSlot in trainer.timeSlots" :key="timeSlot.id" :value="timeSlot.id">
                        {{ timeSlot.slot }}
                      </option>
                    </select>
                    <button
                      v-if="!isTrainerSelected(trainer.id)"
                      class="btn btn-primary btn-sm ms-1 mt-2"
                      @click.stop="selectTrainer(trainer.id, selectedTimeSlot[trainer.id])"
                    >Add</button>
                    <button v-else class="btn btn-secondary btn-sm ms-1 mt-2" disabled>Added</button>
                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Selected Trainers -->
      <div class="col-md-5">
        <h2 class="mb-4">Selected Trainers</h2>
        <ul class="list-group">
          <li class="list-group-item" v-for="selectedTrainer in selectedTrainersWithTimeSlot" :key="selectedTrainer.id">
            <div class="d-flex justify-content-between align-items-center">
              <div>
                {{ selectedTrainer.name }} - {{ selectedTrainer.speciality }} {{ selectedTrainer.timeSlot.slot }}
              </div>
              <button class="btn btn-danger btn-sm" @click="removeTrainer(selectedTrainer.id)">Remove</button>
            </div>
          </li>
        </ul>
      </div>
    </div>
  </div>

  <!-- Fullscreen Trainer Overlay -->
  <Teleport to="body">
    <div v-if="activeTrainer" class="trainer-overlay" @click.self="closeTrainer">
      <div class="trainer-panel">
        <!-- Close Button -->
        <button class="btn-close-overlay" @click="closeTrainer">✕</button>

        <!-- Header -->
        <div class="trainer-panel-header">
          <div class="trainer-avatar">{{ activeTrainer.name.charAt(0).toUpperCase() }}</div>
          <div>
            <h2 class="mb-0">{{ activeTrainer.name }}</h2>
            <span class="badge bg-primary mt-1">{{ activeTrainer.speciality }}</span>
          </div>
        </div>

        <!-- Bio -->
        <div class="trainer-section">
          <h5>About</h5>
          <p class="text-muted">{{ activeTrainer.bio || 'No biography available for this trainer yet.' }}</p>
        </div>

        <!-- Contact -->
        <div class="trainer-section">
          <h5>Contact</h5>
          <p class="mb-0"><span class="text-muted">Email:</span> {{ activeTrainer.email }}</p>
        </div>

        <!-- Time Slots -->
        <div class="trainer-section">
          <h5>Available Time Slots</h5>
          <div v-if="activeTrainer.timeSlots?.length > 0" class="d-flex flex-wrap gap-2">
            <span v-for="slot in activeTrainer.timeSlots" :key="slot.id" class="badge bg-success fs-6 p-2">
              {{ slot.slot }}
            </span>
          </div>
          <p v-else class="text-muted">No time slots available.</p>
        </div>

        <!-- Book -->
        <div class="trainer-section">
          <div class="mb-2">
            <label class="form-label fw-bold">Select Time Slot to Book</label>
            <select v-model="selectedTimeSlot[activeTrainer.id]" class="form-select">
              <option v-for="timeSlot in activeTrainer.timeSlots" :key="timeSlot.id" :value="timeSlot.id">
                {{ timeSlot.slot }}
              </option>
            </select>
          </div>
          <button
            v-if="!isTrainerSelected(activeTrainer.id)"
            class="btn btn-primary w-100"
            @click="selectTrainer(activeTrainer.id, selectedTimeSlot[activeTrainer.id]); closeTrainer()"
          >Book This Trainer</button>
          <button v-else class="btn btn-secondary w-100" disabled>Already Booked</button>
        </div>
      </div>
    </div>
  </Teleport>
</template>

<style>
.profile-card {
  border: 1px solid #ccc;
  border-radius: 10px;
  box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
  cursor: pointer;
  transition: box-shadow 0.2s;
}

.profile-card:hover {
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.15);
}

.profile-card .card-body { padding: 20px; }
.profile-card .card-title { font-size: 1.5rem; margin-bottom: 5px; }
.profile-card .card-text { font-size: 1.1rem; color: #666; }
.profile-card .list-group-item { border: none; }

/* Overlay */
.trainer-overlay {
  position: fixed;
  inset: 0;
  background: rgba(0, 0, 0, 0.6);
  z-index: 9999;
  display: flex;
  justify-content: flex-end;
}

.trainer-panel {
  background: #fff;
  width: 100%;
  max-width: 520px;
  height: 100vh;
  overflow-y: auto;
  padding: 2rem;
  position: relative;
  animation: slideIn 0.25s ease;
}

@keyframes slideIn {
  from { transform: translateX(100%); }
  to { transform: translateX(0); }
}

.btn-close-overlay {
  position: absolute;
  top: 1rem;
  right: 1rem;
  background: none;
  border: none;
  font-size: 1.5rem;
  cursor: pointer;
  color: #666;
}

.trainer-panel-header {
  display: flex;
  align-items: center;
  gap: 1.5rem;
  margin-bottom: 2rem;
  padding-bottom: 1rem;
  border-bottom: 1px solid #eee;
}

.trainer-avatar {
  width: 72px;
  height: 72px;
  border-radius: 50%;
  background: #0d6efd;
  color: white;
  font-size: 2rem;
  display: flex;
  align-items: center;
  justify-content: center;
  font-weight: bold;
  flex-shrink: 0;
}

.trainer-section {
  margin-bottom: 1.5rem;
  padding-bottom: 1.5rem;
  border-bottom: 1px solid #f0f0f0;
}

.trainer-section:last-child {
  border-bottom: none;
}
</style>