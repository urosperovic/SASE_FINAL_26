<script>
import { TrainerService } from "@/services/trainer.service";
import { UserService } from "@/services/user.service";
import { SessionManager } from "@/utils/session.manager";

export default {
  data() {
    return { selectedTrainersWithTimeSlot: [] };
  },
  async created() {
    if (!SessionManager.hasAuth()) { this.$router.push("/login"); return; }
    await this.fetchSelectedTrainers();
  },
  methods: {
    async fetchSelectedTrainers() {
      try {
        const user = await UserService.getUserProfile();
        const response = await TrainerService.getSelectedTrainers(user.data.id);
        const result = [];
        for (const item of response.data) {
          const trainerRes = await TrainerService.getTrainerById(item.trainer_id);
          const timeSlotRes = await TrainerService.getTimeSlots(item.timeSlot_id);
          result.push({ ...trainerRes.data, timeSlot: timeSlotRes.data });
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
  <div class="selected-page">
    <div class="selected-header">
      <p class="selected-eyebrow">⚡ IRONFORGE</p>
      <h1 class="selected-title">My Trainers</h1>
      <p class="selected-sub">Your personal training squad.</p>
    </div>

    <div class="selected-body">
      <!-- Empty -->
      <div v-if="selectedTrainersWithTimeSlot.length === 0" class="empty-state">
        <div class="empty-icon">🏋️</div>
        <h3>No trainers selected yet</h3>
        <p>Head back to the home page and book your first trainer.</p>
        <router-link to="/" class="btn-go-home">Browse Trainers</router-link>
      </div>

      <!-- List -->
      <div v-else class="selected-grid">
        <div
          v-for="trainer in selectedTrainersWithTimeSlot"
          :key="trainer.id"
          class="selected-card"
        >
          <div class="card-avatar">{{ trainer.name.charAt(0) }}</div>
          <div class="card-info">
            <h3 class="card-name">{{ trainer.name }}</h3>
            <p class="card-spec">{{ trainer.speciality }}</p>
            <div class="card-slot">
              <span class="slot-icon">🕐</span>
              {{ trainer.timeSlot?.slot }}
            </div>
          </div>
          <button class="btn-remove" @click="removeTrainer(trainer.id)">
            <span>Remove</span>
          </button>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@700;900&family=DM+Sans:wght@400;500&display=swap');

.selected-page { min-height: 100vh; background: #0f0f0f; font-family: 'DM Sans', sans-serif; color: #fff; }

.selected-header {
  background: #111; border-bottom: 1px solid #222;
  padding: 2rem 3rem; position: relative; overflow: hidden;
}
.selected-header::after {
  content: 'SQUAD';
  position: absolute; right: -1rem; top: 50%; transform: translateY(-50%);
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 10rem; font-weight: 900;
  color: rgba(255,255,255,0.02); pointer-events: none;
}
.selected-eyebrow { color: #e8ff00; font-size: 0.75rem; letter-spacing: 3px; text-transform: uppercase; margin: 0 0 0.25rem; }
.selected-title { font-family: 'Barlow Condensed', sans-serif; font-size: 3rem; font-weight: 900; margin: 0 0 0.5rem; }
.selected-sub { color: #666; font-size: 0.9rem; margin: 0; }

.selected-body { padding: 2.5rem 3rem; }

.empty-state {
  text-align: center; padding: 4rem 2rem;
  background: #141414; border: 1px dashed #2a2a2a;
  border-radius: 16px; max-width: 400px; margin: 0 auto;
}
.empty-icon { font-size: 3rem; margin-bottom: 1rem; }
.empty-state h3 { font-family: 'Barlow Condensed', sans-serif; font-size: 1.5rem; font-weight: 700; margin: 0 0 0.5rem; }
.empty-state p { color: #555; font-size: 0.9rem; margin: 0 0 1.5rem; }
.btn-go-home {
  display: inline-block;
  background: #e8ff00; color: #0a0a0a;
  padding: 0.75rem 1.5rem; border-radius: 8px;
  font-family: 'Barlow Condensed', sans-serif;
  font-weight: 700; font-size: 1rem; letter-spacing: 1px;
  text-decoration: none; text-transform: uppercase;
  transition: opacity 0.2s;
}
.btn-go-home:hover { opacity: 0.85; }

.selected-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 1rem; }

.selected-card {
  background: #141414; border: 1px solid #222; border-radius: 12px;
  padding: 1.5rem; display: flex; align-items: center; gap: 1rem;
  transition: border-color 0.2s;
}
.selected-card:hover { border-color: #2a2a2a; }

.card-avatar {
  width: 56px; height: 56px;
  background: #e8ff00; color: #0a0a0a;
  border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 1.6rem; font-weight: 900; flex-shrink: 0;
}

.card-info { flex: 1; }
.card-name { font-family: 'Barlow Condensed', sans-serif; font-size: 1.3rem; font-weight: 700; margin: 0 0 0.2rem; color: #fff; }
.card-spec { font-size: 0.8rem; color: #666; margin: 0 0 0.5rem; }
.card-slot { font-size: 0.85rem; color: #e8ff00; display: flex; align-items: center; gap: 0.4rem; }
.slot-icon { font-size: 0.9rem; }

.btn-remove {
  background: rgba(255,68,68,0.08);
  border: 1px solid rgba(255,68,68,0.25);
  color: #ff4444; padding: 0.5rem 1rem;
  border-radius: 7px; font-size: 0.85rem;
  cursor: pointer; transition: all 0.2s; flex-shrink: 0;
}
.btn-remove:hover { background: rgba(255,68,68,0.18); }

@media (max-width: 768px) {
  .selected-body { padding: 1.5rem; }
  .selected-grid { grid-template-columns: 1fr; }
}
</style>