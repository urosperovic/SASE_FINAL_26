<script>
import { TrainerService } from "@/services/trainer.service";
import { UserService } from "@/services/user.service";
import { SessionManager } from "@/utils/session.manager";

export default {
  data() {
    return {
      selectedTrainersWithTimeSlot: []
    };
  },

  async created() {
    if (!SessionManager.hasAuth()) {
      this.$router.push("/login");
      return;
    }

    await this.fetchSelectedTrainers();
  },

  methods: {
    async fetchSelectedTrainers() {
      try {
        const user = await UserService.getUserProfile();
        const userId = user.data.id;

        const response = await TrainerService.getSelectedTrainers(userId);
        const data = response.data;

        const result = [];

        for (const item of data) {
          const trainerRes = await TrainerService.getTrainerById(item.trainer_id);
          const timeSlotRes = await TrainerService.getTimeSlots(item.timeSlot_id);

          result.push({
            ...trainerRes.data,
            timeSlot: timeSlotRes.data
          });
        }

        this.selectedTrainersWithTimeSlot = result;
      } catch (error) {
        console.error("Failed to fetch selected trainers:", error);
      }
    },

    async removeTrainer(trainerId) {
      try {
        const user = await UserService.getUserProfile();
        await TrainerService.unpickTrainer(trainerId, user.data.id);

        await this.fetchSelectedTrainers();
      } catch (error) {
        console.error("Failed to remove trainer:", error);
      }
    }
  }
};
</script>

<template>
  <div class="container mt-5">
    <h1 class="mb-4">My Selected Trainers</h1>

    <div v-if="selectedTrainersWithTimeSlot.length === 0" class="alert alert-info">
      You have no selected trainers yet.
    </div>

    <ul class="list-group">
      <li
        v-for="trainer in selectedTrainersWithTimeSlot"
        :key="trainer.id"
        class="list-group-item"
      >
        <div class="d-flex justify-content-between align-items-center">
          <div>
            <h5 class="mb-1">{{ trainer.name }}</h5>
            <p class="mb-0 text-muted">
              {{ trainer.speciality }} - {{ trainer.timeSlot.slot }}
            </p>
          </div>

          <button
            class="btn btn-danger btn-sm"
            @click="removeTrainer(trainer.id)"
          >
            Remove
          </button>
        </div>
      </li>
    </ul>
  </div>
</template>

<style>
.list-group-item {
  border-radius: 10px;
  margin-bottom: 10px;
}
</style>