<template>
  <div class="ex-page">
    <div class="ex-header">
      <div>
        <p class="ex-eyebrow">⚡ IRONFORGE</p>
        <h1 class="ex-title">Exercise Library</h1>
        <p class="ex-sub">Browse hundreds of exercises with step-by-step instructions.</p>
      </div>
    </div>

    <div class="ex-body">
      <!-- Filters -->
      <div class="ex-filters">
        <input
          class="filter-input"
          v-model="searchQuery"
          placeholder="Search exercises..."
          @input="onSearch"
        />
        <select class="filter-select" v-model="selectedBodyPart" @change="onFilter">
          <option value="">All Body Parts</option>
          <option v-for="part in bodyParts" :key="part" :value="part">
            {{ part.charAt(0).toUpperCase() + part.slice(1) }}
          </option>
        </select>
        <button class="btn-reset" @click="resetFilters">Reset</button>
      </div>

      <!-- Loading -->
      <div v-if="loading" class="ex-loading">
        <div class="spinner"></div>
        <p>Loading exercises...</p>
      </div>

      <!-- Error -->
      <div v-else-if="error" class="ex-error">{{ error }}</div>

      <!-- List -->
      <div v-else class="ex-list">
        <div
          v-for="exercise in exercises"
          :key="exercise.id"
          class="ex-card"
          :class="{ expanded: expandedId === exercise.id }"
          @click="toggleExpand(exercise.id)"
        >
          <img :src="exercise.gifUrl" :alt="exercise.name" class="ex-gif" />
          <div class="ex-info">
            <div class="ex-info-top">
              <span class="ex-name">{{ exercise.name }}</span>
              <span class="ex-badge">{{ exercise.bodyPart }}</span>
            </div>
            <p class="ex-meta">Target: {{ exercise.target }} · Equipment: {{ exercise.equipment }}</p>

            <div v-if="expandedId === exercise.id" class="ex-instructions">
              <p class="instructions-label">Instructions</p>
              <ol>
                <li v-for="(step, i) in exercise.instructions" :key="i">{{ step }}</li>
              </ol>
            </div>
          </div>
          <span class="ex-expand-icon">{{ expandedId === exercise.id ? '▲' : '▼' }}</span>
        </div>
      </div>

      <!-- Pagination -->
      <div v-if="!loading && !error" class="ex-pagination">
        <button class="btn-page" :disabled="offset === 0" @click="prevPage">← Prev</button>
        <span class="page-num">Page {{ currentPage }}</span>
        <button class="btn-page" :disabled="exercises.length < limit" @click="nextPage">Next →</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { ExerciseService } from '@/services/exerciseService'

const exercises = ref([])
const bodyParts = ref([])
const searchQuery = ref('')
const selectedBodyPart = ref('')
const loading = ref(false)
const error = ref('')
const expandedId = ref(null)
const limit = 20
const offset = ref(0)
const currentPage = ref(1)
let searchTimeout: any = null

const fetchExercises = async () => {
  loading.value = true
  error.value = ''
  try {
    const res = await ExerciseService.getExercises(searchQuery.value || undefined, selectedBodyPart.value || undefined, limit, offset.value)
    exercises.value = res.data
  } catch {
    error.value = 'Failed to load exercises. Please try again.'
  } finally {
    loading.value = false
  }
}

const fetchBodyParts = async () => {
  try {
    const res = await ExerciseService.getBodyParts()
    bodyParts.value = res.data
  } catch {}
}

const onSearch = () => {
  clearTimeout(searchTimeout)
  selectedBodyPart.value = ''
  offset.value = 0
  currentPage.value = 1
  searchTimeout = setTimeout(fetchExercises, 500)
}

const onFilter = () => {
  searchQuery.value = ''
  offset.value = 0
  currentPage.value = 1
  fetchExercises()
}

const resetFilters = () => {
  searchQuery.value = ''
  selectedBodyPart.value = ''
  offset.value = 0
  currentPage.value = 1
  fetchExercises()
}

const toggleExpand = (id: string) => {
  expandedId.value = expandedId.value === id ? null : id
}

const nextPage = () => { offset.value += limit; currentPage.value++; fetchExercises() }
const prevPage = () => { offset.value = Math.max(0, offset.value - limit); currentPage.value--; fetchExercises() }

onMounted(() => { fetchExercises(); fetchBodyParts() })
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@700;900&family=DM+Sans:wght@400;500&display=swap');

.ex-page { min-height: 100vh; background: #0f0f0f; font-family: 'DM Sans', sans-serif; color: #fff; }

.ex-header {
  background: #111;
  border-bottom: 1px solid #222;
  padding: 2rem 3rem;
  position: relative;
  overflow: hidden;
}
.ex-header::after {
  content: 'LIFT';
  position: absolute;
  right: -1rem; top: 50%;
  transform: translateY(-50%);
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 10rem; font-weight: 900;
  color: rgba(255,255,255,0.02);
  pointer-events: none;
}
.ex-eyebrow { color: #e8ff00; font-size: 0.75rem; letter-spacing: 3px; text-transform: uppercase; margin: 0 0 0.25rem; }
.ex-title { font-family: 'Barlow Condensed', sans-serif; font-size: 3rem; font-weight: 900; margin: 0 0 0.5rem; }
.ex-sub { color: #666; font-size: 0.9rem; margin: 0; }

.ex-body { padding: 2rem 3rem; }

.ex-filters { display: flex; gap: 1rem; margin-bottom: 2rem; }

.filter-input {
  flex: 1;
  background: #1a1a1a; border: 1px solid #2a2a2a; color: #fff;
  padding: 0.75rem 1rem; border-radius: 8px;
  font-size: 0.9rem; font-family: 'DM Sans', sans-serif;
  outline: none; transition: border-color 0.2s;
}
.filter-input:focus { border-color: #e8ff00; }
.filter-input::placeholder { color: #444; }

.filter-select {
  background: #1a1a1a; border: 1px solid #2a2a2a; color: #fff;
  padding: 0.75rem 1rem; border-radius: 8px;
  font-size: 0.9rem; font-family: 'DM Sans', sans-serif;
  outline: none; min-width: 180px;
}

.btn-reset {
  background: #1a1a1a; border: 1px solid #2a2a2a; color: #888;
  padding: 0.75rem 1.25rem; border-radius: 8px;
  font-size: 0.85rem; cursor: pointer;
  transition: all 0.2s; white-space: nowrap;
}
.btn-reset:hover { border-color: #444; color: #fff; }

.ex-loading { text-align: center; padding: 4rem 0; color: #555; }
.spinner {
  width: 36px; height: 36px;
  border: 3px solid #222; border-top-color: #e8ff00;
  border-radius: 50%; animation: spin 0.8s linear infinite;
  margin: 0 auto 1rem;
}
@keyframes spin { to { transform: rotate(360deg); } }

.ex-error { background: rgba(255,68,68,0.1); border: 1px solid rgba(255,68,68,0.3); color: #ff4444; padding: 1rem; border-radius: 8px; }

.ex-list { display: flex; flex-direction: column; gap: 0.75rem; }

.ex-card {
  background: #141414; border: 1px solid #222; border-radius: 10px;
  padding: 1.25rem; display: flex; align-items: center; gap: 1.25rem;
  cursor: pointer; transition: border-color 0.2s, background 0.2s;
}
.ex-card:hover { border-color: #333; background: #181818; }
.ex-card.expanded { border-color: #e8ff00; }

.ex-gif { width: 80px; height: 80px; object-fit: cover; border-radius: 8px; flex-shrink: 0; background: #1a1a1a; }

.ex-info { flex: 1; }
.ex-info-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.3rem; }
.ex-name { font-weight: 600; font-size: 0.95rem; text-transform: capitalize; color: #fff; }
.ex-badge { background: rgba(232,255,0,0.1); color: #e8ff00; font-size: 0.7rem; padding: 0.2rem 0.6rem; border-radius: 4px; text-transform: capitalize; letter-spacing: 0.5px; }
.ex-meta { font-size: 0.8rem; color: #555; margin: 0; text-transform: capitalize; }

.ex-instructions { margin-top: 1rem; padding-top: 1rem; border-top: 1px solid #222; }
.instructions-label { font-size: 0.75rem; text-transform: uppercase; letter-spacing: 1px; color: #555; margin: 0 0 0.5rem; }
.ex-instructions ol { margin: 0; padding-left: 1.25rem; }
.ex-instructions li { font-size: 0.85rem; color: #aaa; line-height: 1.6; margin-bottom: 0.3rem; }

.ex-expand-icon { color: #333; font-size: 0.7rem; flex-shrink: 0; }
.ex-card.expanded .ex-expand-icon { color: #e8ff00; }

.ex-pagination { display: flex; align-items: center; justify-content: space-between; margin-top: 2rem; padding-top: 2rem; border-top: 1px solid #1e1e1e; }
.btn-page {
  background: #1a1a1a; border: 1px solid #2a2a2a; color: #fff;
  padding: 0.65rem 1.25rem; border-radius: 7px;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 1rem; font-weight: 700; letter-spacing: 1px;
  cursor: pointer; transition: all 0.2s;
}
.btn-page:hover:not(:disabled) { border-color: #e8ff00; color: #e8ff00; }
.btn-page:disabled { opacity: 0.3; cursor: not-allowed; }
.page-num { font-size: 0.85rem; color: #555; }

@media (max-width: 768px) {
  .ex-body { padding: 1.5rem; }
  .ex-filters { flex-direction: column; }
}
</style>