<template>
  <div class="container mt-4">
    <h2 class="mb-4">Exercise Library</h2>

    <!-- Filters -->
    <div class="row mb-4 g-2">
      <div class="col-md-6">
        <input
          class="form-control"
          v-model="searchQuery"
          placeholder="Search exercises..."
          @input="onSearch"
        />
      </div>
      <div class="col-md-4">
        <select class="form-select" v-model="selectedBodyPart" @change="onFilter">
          <option value="">All Body Parts</option>
          <option v-for="part in bodyParts" :key="part" :value="part">
            {{ part.charAt(0).toUpperCase() + part.slice(1) }}
          </option>
        </select>
      </div>
      <div class="col-md-2">
        <button class="btn btn-secondary w-100" @click="resetFilters">Reset</button>
      </div>
    </div>

    <!-- Loading -->
    <div v-if="loading" class="text-center py-5">
      <div class="spinner-border text-primary" role="status"></div>
      <p class="mt-2">Loading exercises...</p>
    </div>

    <!-- Error -->
    <div v-else-if="error" class="alert alert-danger">{{ error }}</div>

    <!-- Exercise List -->
    <div v-else>
      <div class="list-group">
        <div
          v-for="exercise in exercises"
          :key="exercise.id"
          class="list-group-item list-group-item-action d-flex align-items-center gap-3 py-3"
          @click="toggleExpand(exercise.id)"
          style="cursor: pointer"
        >
          <img :src="exercise.gifUrl" :alt="exercise.name" width="80" height="80" style="object-fit: cover; border-radius: 8px;" />
          <div class="flex-grow-1">
            <div class="d-flex justify-content-between">
              <strong class="text-capitalize">{{ exercise.name }}</strong>
              <span class="badge bg-primary text-capitalize">{{ exercise.bodyPart }}</span>
            </div>
            <small class="text-muted text-capitalize">Target: {{ exercise.target }} · Equipment: {{ exercise.equipment }}</small>

            <!-- Expanded instructions -->
            <div v-if="expandedId === exercise.id" class="mt-2">
              <p class="mb-1 fw-semibold">Instructions:</p>
              <ol class="mb-0 ps-3">
                <li v-for="(step, i) in exercise.instructions" :key="i" class="small">{{ step }}</li>
              </ol>
            </div>
          </div>
        </div>
      </div>

      <!-- Pagination -->
      <div class="d-flex justify-content-between align-items-center mt-4">
        <button class="btn btn-outline-primary" :disabled="offset === 0" @click="prevPage">← Previous</button>
        <span class="text-muted">Page {{ currentPage }}</span>
        <button class="btn btn-outline-primary" :disabled="exercises.length < limit" @click="nextPage">Next →</button>
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
    const res = await ExerciseService.getExercises(
      searchQuery.value || undefined,
      selectedBodyPart.value || undefined,
      limit,
      offset.value
    )
    exercises.value = res.data
  } catch (e: any) {
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

const nextPage = () => {
  offset.value += limit
  currentPage.value++
  fetchExercises()
}

const prevPage = () => {
  offset.value = Math.max(0, offset.value - limit)
  currentPage.value--
  fetchExercises()
}

onMounted(() => {
  fetchExercises()
  fetchBodyParts()
})
</script>