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
        const trainerIds = trainers.map(t => t.trainer_id);
        const timeSlots = trainers.map(t => t.timeSlot_id);
        const selectedTimeSlot = [];
        for (const ts of timeSlots) {
          const t = await TrainerService.getTimeSlots(ts);
          selectedTimeSlot.push(t.data);
        }
        const selectedTrainers = [];
        for (const id of trainerIds) {
          const t = await TrainerService.getTrainerById(id);
          selectedTrainers.push(t.data);
        }
        this.selectedTrainers = selectedTrainers;
        this.selectedTimeSlot = selectedTimeSlot;
        this.selectedTrainersWithTimeSlot = selectedTrainers.map((t, i) => ({ ...t, timeSlot: selectedTimeSlot[i] }));
      } catch (error) {
        console.error("Failed to fetch selected trainers:", error);
      }
    },
    isTrainerSelected(id) {
      return this.selectedTrainers.some(t => t.id === id);
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
      return this.trainers.filter(t => !this.isTrainerSelected(t.id));
    }
  }
};
</script>

<template>
  <div class="home-page">
    <!-- Hero -->
    <div class="home-hero">
      <div class="hero-content">
        <p class="hero-eyebrow">⚡ IRONFORGE GYM</p>
        <h1 class="hero-heading">Find Your <span class="accent">Trainer</span></h1>
        <p class="hero-desc">Hand-picked elite trainers ready to push you beyond your limits.</p>
      </div>
    </div>

    <div class="home-body">
      <!-- Available -->
      <div class="section-main">
        <div class="section-header">
          <h2 class="section-title">Available Trainers</h2>
          <span class="section-count">{{ availableTrainers.length }} trainers</span>
        </div>
        <div class="trainers-grid">
          <div
            v-for="trainer in availableTrainers"
            :key="trainer.id"
            class="trainer-card"
            @click="openTrainer(trainer)"
          >
            <div class="trainer-card-avatar">{{ trainer.name.charAt(0) }}</div>
            <div class="trainer-card-info">
              <h3 class="trainer-name">{{ trainer.name }}</h3>
              <p class="trainer-spec">{{ trainer.speciality }}</p>
              <div class="trainer-slots-preview">
                <span v-for="slot in trainer.timeSlots?.slice(0,2)" :key="slot.id" class="slot-pill">{{ slot.slot }}</span>
                <span v-if="trainer.timeSlots?.length > 2" class="slot-pill muted">+{{ trainer.timeSlots.length - 2 }}</span>
              </div>
            </div>
            <div class="trainer-card-action" @click.stop>
              <select v-model="selectedTimeSlot[trainer.id]" class="slot-select">
                <option disabled value="">Pick slot</option>
                <option v-for="ts in trainer.timeSlots" :key="ts.id" :value="ts.id">{{ ts.slot }}</option>
              </select>
              <button
                v-if="!isTrainerSelected(trainer.id)"
                class="btn-book"
                @click.stop="selectTrainer(trainer.id, selectedTimeSlot[trainer.id])"
              >Book</button>
              <button v-else class="btn-booked" disabled>Booked</button>
            </div>
          </div>
        </div>
      </div>

      <!-- Selected -->
      <div class="section-sidebar">
        <h2 class="section-title">My Trainers</h2>
        <div v-if="selectedTrainersWithTimeSlot.length === 0" class="empty-state">
          <p>No trainers booked yet.</p>
          <span>Pick one from the left!</span>
        </div>
        <div v-for="t in selectedTrainersWithTimeSlot" :key="t.id" class="selected-card">
          <div class="selected-avatar">{{ t.name.charAt(0) }}</div>
          <div class="selected-info">
            <p class="selected-name">{{ t.name }}</p>
            <p class="selected-detail">{{ t.speciality }}</p>
            <p class="selected-slot">🕐 {{ t.timeSlot?.slot }}</p>
          </div>
          <button class="btn-remove" @click="removeTrainer(t.id)">✕</button>
        </div>
      </div>
    </div>
  </div>

  <!-- Overlay -->
  <Teleport to="body">
    <div v-if="activeTrainer" class="overlay" @click.self="closeTrainer">
      <div class="drawer">
        <button class="drawer-close" @click="closeTrainer">✕</button>

        <div class="drawer-header">
          <div class="drawer-avatar">{{ activeTrainer.name.charAt(0) }}</div>
          <div>
            <h2 class="drawer-name">{{ activeTrainer.name }}</h2>
            <span class="drawer-spec">{{ activeTrainer.speciality }}</span>
          </div>
        </div>

        <div class="drawer-section">
          <h4>About</h4>
          <p>{{ activeTrainer.bio || 'No biography available for this trainer yet.' }}</p>
        </div>

        <div class="drawer-section">
          <h4>Contact</h4>
          <p>{{ activeTrainer.email }}</p>
        </div>

        <div class="drawer-section">
          <h4>Available Slots</h4>
          <div class="slots-wrap">
            <span v-for="slot in activeTrainer.timeSlots" :key="slot.id" class="slot-tag">{{ slot.slot }}</span>
            <p v-if="!activeTrainer.timeSlots?.length" class="muted-text">No slots available.</p>
          </div>
        </div>

        <div class="drawer-section">
          <h4>Book This Trainer</h4>
          <select v-model="selectedTimeSlot[activeTrainer.id]" class="slot-select-full">
            <option disabled value="">Select a time slot</option>
            <option v-for="ts in activeTrainer.timeSlots" :key="ts.id" :value="ts.id">{{ ts.slot }}</option>
          </select>
          <button
            v-if="!isTrainerSelected(activeTrainer.id)"
            class="btn-book-full"
            @click="selectTrainer(activeTrainer.id, selectedTimeSlot[activeTrainer.id]); closeTrainer()"
          >Book Now</button>
          <button v-else class="btn-booked-full" disabled>Already Booked</button>
        </div>
      </div>
    </div>
  </Teleport>
</template>

<style>
@import url('https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@700;900&family=DM+Sans:wght@400;500&display=swap');

.home-page { min-height: 100vh; background: #0f0f0f; font-family: 'DM Sans', sans-serif; color: #fff; }

.home-hero {
  background: linear-gradient(135deg, #111 0%, #1a1a1a 100%);
  padding: 4rem 3rem 3rem;
  border-bottom: 1px solid #222;
  position: relative;
  overflow: hidden;
}
.home-hero::after {
  content: 'TRAIN';
  position: absolute;
  right: -1rem;
  top: 50%;
  transform: translateY(-50%);
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12rem;
  font-weight: 900;
  color: rgba(255,255,255,0.03);
  line-height: 1;
  pointer-events: none;
}

.hero-eyebrow { color: #e8ff00; font-size: 0.8rem; letter-spacing: 3px; text-transform: uppercase; margin-bottom: 0.75rem; }
.hero-heading { font-family: 'Barlow Condensed', sans-serif; font-size: 5rem; font-weight: 900; line-height: 0.95; margin: 0 0 1rem; }
.accent { color: #e8ff00; }
.hero-desc { color: #666; font-size: 1rem; max-width: 500px; }

.home-body { display: flex; gap: 2rem; padding: 2.5rem 3rem; align-items: flex-start; }

.section-main { flex: 1; }
.section-sidebar { width: 320px; position: sticky; top: 1rem; }

.section-header { display: flex; align-items: baseline; justify-content: space-between; margin-bottom: 1.5rem; }
.section-title { font-family: 'Barlow Condensed', sans-serif; font-size: 1.8rem; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; color: #fff; }
.section-count { font-size: 0.8rem; color: #555; text-transform: uppercase; letter-spacing: 1px; }

.trainers-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 1rem; }

.trainer-card {
  background: #1a1a1a;
  border: 1px solid #2a2a2a;
  border-radius: 12px;
  padding: 1.25rem;
  cursor: pointer;
  transition: border-color 0.2s, transform 0.2s;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}
.trainer-card:hover { border-color: #e8ff00; transform: translateY(-2px); }

.trainer-card-avatar {
  width: 52px; height: 52px;
  background: #e8ff00;
  color: #0a0a0a;
  border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 1.5rem; font-weight: 900;
}

.trainer-name { font-family: 'Barlow Condensed', sans-serif; font-size: 1.3rem; font-weight: 700; margin: 0; color: #fff; }
.trainer-spec { font-size: 0.85rem; color: #888; margin: 0.2rem 0 0.6rem; }

.trainer-slots-preview { display: flex; gap: 0.4rem; flex-wrap: wrap; }
.slot-pill { background: #252525; color: #aaa; font-size: 0.7rem; padding: 0.2rem 0.5rem; border-radius: 4px; }
.slot-pill.muted { color: #555; }

.trainer-card-action { display: flex; gap: 0.5rem; align-items: center; }

.slot-select {
  flex: 1;
  background: #252525;
  border: 1px solid #333;
  color: #fff;
  padding: 0.5rem 0.75rem;
  border-radius: 6px;
  font-size: 0.8rem;
  font-family: 'DM Sans', sans-serif;
  outline: none;
}

.btn-book {
  background: #e8ff00;
  color: #0a0a0a;
  border: none;
  padding: 0.5rem 1rem;
  border-radius: 6px;
  font-family: 'Barlow Condensed', sans-serif;
  font-weight: 700;
  font-size: 0.9rem;
  letter-spacing: 1px;
  cursor: pointer;
  transition: opacity 0.2s;
  white-space: nowrap;
}
.btn-book:hover { opacity: 0.85; }
.btn-booked { background: #2a2a2a; color: #555; border: none; padding: 0.5rem 1rem; border-radius: 6px; font-size: 0.85rem; cursor: not-allowed; }

/* Sidebar */
.empty-state { background: #1a1a1a; border: 1px dashed #333; border-radius: 12px; padding: 2rem; text-align: center; color: #555; }
.empty-state p { font-size: 1rem; margin: 0 0 0.25rem; }
.empty-state span { font-size: 0.8rem; }

.selected-card {
  background: #1a1a1a;
  border: 1px solid #2a2a2a;
  border-radius: 10px;
  padding: 1rem;
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 0.75rem;
}
.selected-avatar {
  width: 40px; height: 40px;
  background: #e8ff00;
  color: #0a0a0a;
  border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 1.1rem; font-weight: 900;
  flex-shrink: 0;
}
.selected-info { flex: 1; }
.selected-name { font-weight: 600; font-size: 0.9rem; margin: 0; color: #fff; }
.selected-detail { font-size: 0.75rem; color: #666; margin: 0; }
.selected-slot { font-size: 0.75rem; color: #e8ff00; margin: 0.2rem 0 0; }
.btn-remove { background: none; border: 1px solid #333; color: #666; width: 28px; height: 28px; border-radius: 50%; cursor: pointer; font-size: 0.75rem; transition: all 0.2s; flex-shrink: 0; }
.btn-remove:hover { border-color: #ff4444; color: #ff4444; }

/* Overlay */
.overlay {
  position: fixed; inset: 0;
  background: rgba(0,0,0,0.75);
  z-index: 9999;
  display: flex;
  justify-content: flex-end;
}

.drawer {
  background: #141414;
  width: 100%;
  max-width: 500px;
  height: 100vh;
  overflow-y: auto;
  padding: 2.5rem;
  position: relative;
  animation: slideIn 0.25s ease;
  border-left: 1px solid #2a2a2a;
}

@keyframes slideIn {
  from { transform: translateX(100%); }
  to { transform: translateX(0); }
}

.drawer-close {
  position: absolute; top: 1.5rem; right: 1.5rem;
  background: #2a2a2a; border: none; color: #fff;
  width: 36px; height: 36px; border-radius: 50%;
  font-size: 1rem; cursor: pointer;
  transition: background 0.2s;
}
.drawer-close:hover { background: #333; }

.drawer-header {
  display: flex; align-items: center; gap: 1.25rem;
  margin-bottom: 2rem; padding-bottom: 1.5rem;
  border-bottom: 1px solid #222;
}

.drawer-avatar {
  width: 64px; height: 64px;
  background: #e8ff00;
  color: #0a0a0a;
  border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 2rem; font-weight: 900;
  flex-shrink: 0;
}

.drawer-name { font-family: 'Barlow Condensed', sans-serif; font-size: 2rem; font-weight: 900; margin: 0; color: #fff; }
.drawer-spec { background: #e8ff00; color: #0a0a0a; font-size: 0.75rem; font-weight: 700; padding: 0.2rem 0.6rem; border-radius: 4px; letter-spacing: 1px; text-transform: uppercase; display: inline-block; margin-top: 0.4rem; }

.drawer-section { margin-bottom: 1.75rem; padding-bottom: 1.75rem; border-bottom: 1px solid #1e1e1e; }
.drawer-section:last-child { border-bottom: none; }
.drawer-section h4 { font-family: 'Barlow Condensed', sans-serif; font-size: 0.8rem; letter-spacing: 2px; text-transform: uppercase; color: #555; margin-bottom: 0.75rem; }
.drawer-section p { color: #aaa; font-size: 0.9rem; line-height: 1.6; margin: 0; }

.slots-wrap { display: flex; flex-wrap: wrap; gap: 0.5rem; }
.slot-tag { background: #1e1e1e; border: 1px solid #333; color: #e8ff00; font-size: 0.8rem; padding: 0.3rem 0.75rem; border-radius: 6px; }
.muted-text { color: #555; font-size: 0.85rem; }

.slot-select-full {
  width: 100%;
  background: #1e1e1e;
  border: 1px solid #333;
  color: #fff;
  padding: 0.75rem 1rem;
  border-radius: 8px;
  font-size: 0.9rem;
  font-family: 'DM Sans', sans-serif;
  outline: none;
  margin-bottom: 0.75rem;
}

.btn-book-full {
  width: 100%;
  background: #e8ff00;
  color: #0a0a0a;
  border: none;
  padding: 1rem;
  border-radius: 8px;
  font-family: 'Barlow Condensed', sans-serif;
  font-weight: 700;
  font-size: 1.1rem;
  letter-spacing: 2px;
  text-transform: uppercase;
  cursor: pointer;
  transition: opacity 0.2s;
}
.btn-book-full:hover { opacity: 0.85; }
.btn-booked-full { width: 100%; background: #2a2a2a; color: #555; border: none; padding: 1rem; border-radius: 8px; font-size: 1rem; cursor: not-allowed; }

@media (max-width: 900px) {
  .home-body { flex-direction: column; padding: 1.5rem; }
  .section-sidebar { width: 100%; position: static; }
  .hero-heading { font-size: 3.5rem; }
}
</style>