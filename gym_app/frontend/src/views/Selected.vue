<script>
import { TrainerService } from "@/services/trainer.service";
import { UserService } from "@/services/user.service";
import { SessionManager } from "@/utils/session.manager";

export default {
  data() {
    return {
      selectedTrainersWithTimeSlot: [],
      currentWeekStart: null,
    };
  },
  async created() {
    if (!SessionManager.hasAuth()) { this.$router.push("/login"); return; }
    this.currentWeekStart = this.getMonday(new Date());
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
    },
    getMonday(date) {
      const d = new Date(date);
      const day = d.getDay();
      const diff = d.getDate() - day + (day === 0 ? -6 : 1);
      d.setDate(diff);
      d.setHours(0, 0, 0, 0);
      return d;
    },
    prevWeek() {
      const d = new Date(this.currentWeekStart);
      d.setDate(d.getDate() - 7);
      this.currentWeekStart = d;
    },
    nextWeek() {
      const d = new Date(this.currentWeekStart);
      d.setDate(d.getDate() + 7);
      this.currentWeekStart = d;
    },
    formatDate(date) {
      return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' });
    },
    isToday(date) {
      const today = new Date();
      return date.toDateString() === today.toDateString();
    },
    // Parse slot string like "Monday 08:00" or "Monday" into day name
    parseDayFromSlot(slot) {
      if (!slot) return null;
      const days = ['monday','tuesday','wednesday','thursday','friday','saturday','sunday'];
      const lower = slot.toLowerCase();
      return days.find(d => lower.startsWith(d)) || null;
    },
    // Parse time from slot string like "Monday 08:00"
    parseTimeFromSlot(slot) {
      if (!slot) return null;
      const match = slot.match(/(\d{1,2}:\d{2})/);
      return match ? match[1] : null;
    },
    // Get trainers scheduled for a specific week day
    getTrainersForDay(weekDay) {
      const dayName = weekDay.toLowerCase();
      return this.selectedTrainersWithTimeSlot.filter(trainer => {
        const slotDay = this.parseDayFromSlot(trainer.timeSlot?.slot);
        return slotDay === dayName;
      });
    },
  },
  computed: {
    weekDays() {
      const days = [];
      const names = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
      const fullNames = ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'];
      for (let i = 0; i < 7; i++) {
        const d = new Date(this.currentWeekStart);
        d.setDate(d.getDate() + i);
        days.push({
          date: d,
          short: names[i],
          full: fullNames[i],
          formatted: this.formatDate(d),
          isToday: this.isToday(d),
        });
      }
      return days;
    },
    weekRangeLabel() {
      if (!this.currentWeekStart) return '';
      const end = new Date(this.currentWeekStart);
      end.setDate(end.getDate() + 6);
      return `${this.formatDate(this.currentWeekStart)} — ${this.formatDate(end)}`;
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

      <div v-else>
        <!-- Trainer Cards -->
        <div class="selected-grid">
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
            <button class="btn-remove" @click="removeTrainer(trainer.id)">Remove</button>
          </div>
        </div>

        <!-- Weekly Calendar -->
        <div class="calendar-wrap">
          <div class="calendar-header">
            <div>
              <h2 class="calendar-title">Weekly Schedule</h2>
              <p class="calendar-range">{{ weekRangeLabel }}</p>
            </div>
            <div class="calendar-nav">
              <button class="nav-btn" @click="prevWeek">← Prev</button>
              <button class="nav-btn today-btn" @click="currentWeekStart = getMonday(new Date())">Today</button>
              <button class="nav-btn" @click="nextWeek">Next →</button>
            </div>
          </div>

          <div class="calendar-grid">
            <!-- Day columns -->
            <div
              v-for="day in weekDays"
              :key="day.full"
              class="day-col"
              :class="{ today: day.isToday }"
            >
              <!-- Day header -->
              <div class="day-header">
                <span class="day-short">{{ day.short }}</span>
                <span class="day-date" :class="{ today: day.isToday }">{{ day.formatted }}</span>
              </div>

              <!-- Sessions -->
              <div class="day-body">
                <div
                  v-for="trainer in getTrainersForDay(day.full)"
                  :key="trainer.id"
                  class="session-card"
                >
                  <div class="session-avatar">{{ trainer.name.charAt(0) }}</div>
                  <div class="session-info">
                    <p class="session-name">{{ trainer.name }}</p>
                    <p class="session-time">{{ parseTimeFromSlot(trainer.timeSlot?.slot) || trainer.timeSlot?.slot }}</p>
                    <p class="session-spec">{{ trainer.speciality }}</p>
                  </div>
                </div>

                <!-- Empty day -->
                <div v-if="getTrainersForDay(day.full).length === 0" class="day-empty">
                  <span>—</span>
                </div>
              </div>
            </div>
          </div>
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
  display: inline-block; background: #e8ff00; color: #0a0a0a;
  padding: 0.75rem 1.5rem; border-radius: 8px;
  font-family: 'Barlow Condensed', sans-serif;
  font-weight: 700; font-size: 1rem; letter-spacing: 1px;
  text-decoration: none; text-transform: uppercase; transition: opacity 0.2s;
}
.btn-go-home:hover { opacity: 0.85; }

/* Trainer Cards */
.selected-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 1rem; margin-bottom: 2.5rem; }

.selected-card {
  background: #141414; border: 1px solid #222; border-radius: 12px;
  padding: 1.5rem; display: flex; align-items: center; gap: 1rem;
  transition: border-color 0.2s;
}
.selected-card:hover { border-color: #2a2a2a; }

.card-avatar {
  width: 56px; height: 56px; background: #e8ff00; color: #0a0a0a;
  border-radius: 50%; display: flex; align-items: center; justify-content: center;
  font-family: 'Barlow Condensed', sans-serif; font-size: 1.6rem; font-weight: 900; flex-shrink: 0;
}
.card-info { flex: 1; }
.card-name { font-family: 'Barlow Condensed', sans-serif; font-size: 1.3rem; font-weight: 700; margin: 0 0 0.2rem; color: #fff; }
.card-spec { font-size: 0.8rem; color: #666; margin: 0 0 0.5rem; }
.card-slot { font-size: 0.85rem; color: #e8ff00; display: flex; align-items: center; gap: 0.4rem; }
.slot-icon { font-size: 0.9rem; }
.btn-remove {
  background: rgba(255,68,68,0.08); border: 1px solid rgba(255,68,68,0.25);
  color: #ff4444; padding: 0.5rem 1rem; border-radius: 7px;
  font-size: 0.85rem; cursor: pointer; transition: all 0.2s; flex-shrink: 0;
}
.btn-remove:hover { background: rgba(255,68,68,0.18); }

/* Calendar */
.calendar-wrap {
  background: #141414; border: 1px solid #222;
  border-radius: 16px; overflow: hidden;
}

.calendar-header {
  display: flex; justify-content: space-between; align-items: center;
  padding: 1.5rem 1.75rem; border-bottom: 1px solid #1e1e1e;
}
.calendar-title {
  font-family: 'Barlow Condensed', sans-serif; font-size: 1.5rem;
  font-weight: 900; margin: 0; text-transform: uppercase; letter-spacing: 1px;
}
.calendar-range { font-size: 0.8rem; color: #555; margin: 0.2rem 0 0; }

.calendar-nav { display: flex; gap: 0.5rem; }
.nav-btn {
  background: #1e1e1e; border: 1px solid #2a2a2a; color: #aaa;
  padding: 0.5rem 1rem; border-radius: 6px;
  font-family: 'Barlow Condensed', sans-serif; font-size: 0.9rem;
  font-weight: 700; letter-spacing: 1px; cursor: pointer; transition: all 0.2s;
}
.nav-btn:hover { border-color: #e8ff00; color: #e8ff00; }
.today-btn { color: #e8ff00; border-color: rgba(232,255,0,0.3); }

.calendar-grid {
  display: grid; grid-template-columns: repeat(7, 1fr);
  min-height: 300px;
}

.day-col {
  border-right: 1px solid #1a1a1a;
  display: flex; flex-direction: column;
}
.day-col:last-child { border-right: none; }
.day-col.today { background: rgba(232,255,0,0.02); }

.day-header {
  padding: 0.75rem 0.5rem; text-align: center;
  border-bottom: 1px solid #1a1a1a;
  display: flex; flex-direction: column; gap: 0.2rem;
}
.day-short {
  font-family: 'Barlow Condensed', sans-serif; font-size: 0.7rem;
  font-weight: 700; letter-spacing: 1px; text-transform: uppercase; color: #555;
}
.day-date {
  font-size: 0.75rem; color: #444;
}
.day-date.today {
  background: #e8ff00; color: #0a0a0a;
  border-radius: 4px; padding: 0.1rem 0.4rem;
  font-weight: 700;
}

.day-body { flex: 1; padding: 0.5rem; display: flex; flex-direction: column; gap: 0.5rem; }

.session-card {
  background: #1e1e1e; border: 1px solid #2a2a2a;
  border-left: 3px solid #e8ff00;
  border-radius: 6px; padding: 0.6rem 0.5rem;
  display: flex; align-items: flex-start; gap: 0.4rem;
}

.session-avatar {
  width: 24px; height: 24px; background: #e8ff00; color: #0a0a0a;
  border-radius: 50%; display: flex; align-items: center; justify-content: center;
  font-family: 'Barlow Condensed', sans-serif; font-size: 0.7rem;
  font-weight: 900; flex-shrink: 0;
}

.session-info { flex: 1; min-width: 0; }
.session-name { font-size: 0.75rem; font-weight: 600; color: #fff; margin: 0; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.session-time { font-size: 0.7rem; color: #e8ff00; margin: 0.1rem 0 0; }
.session-spec { font-size: 0.65rem; color: #555; margin: 0.1rem 0 0; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }

.day-empty { flex: 1; display: flex; align-items: center; justify-content: center; color: #2a2a2a; font-size: 1.2rem; }

@media (max-width: 900px) {
  .selected-body { padding: 1.5rem; }
  .selected-grid { grid-template-columns: 1fr; }
  .calendar-grid { grid-template-columns: repeat(7, minmax(80px, 1fr)); overflow-x: auto; }
  .calendar-wrap { overflow-x: auto; }
}
</style>