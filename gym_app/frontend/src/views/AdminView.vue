<template>
  <div class="container mt-4">
    <h2 class="mb-4">Admin Panel</h2>

    <!-- Tabs -->
    <ul class="nav nav-tabs mb-4">
      <li class="nav-item">
        <a class="nav-link" :class="{ active: tab === 'users' }" @click="tab = 'users'">Users</a>
      </li>
      <li class="nav-item">
        <a class="nav-link" :class="{ active: tab === 'trainers' }" @click="tab = 'trainers'">Trainers</a>
      </li>
    </ul>

    <!-- Users Table -->
    <div v-if="tab === 'users'">
      <h5>All Users</h5>
      <table class="table table-bordered table-hover">
        <thead class="table-dark">
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Role</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="user in users" :key="user.id">
            <td>{{ user.id }}</td>
            <td>{{ user.name }}</td>
            <td>{{ user.email }}</td>
            <td>
              <span class="badge" :class="user.role === 'admin' ? 'bg-danger' : 'bg-secondary'">
                {{ user.role }}
              </span>
            </td>
            <td>
              <button class="btn btn-sm btn-danger" @click="deleteUser(user.id)">Delete</button>
            </td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Trainers Tab -->
    <div v-if="tab === 'trainers'">
      <div class="d-flex justify-content-between align-items-center mb-3">
        <h5 class="mb-0">All Trainers</h5>
        <button class="btn btn-success btn-sm" @click="showAddForm = !showAddForm">
          {{ showAddForm ? 'Cancel' : '+ Add Trainer' }}
        </button>
      </div>

      <!-- Add Trainer Form -->
      <div v-if="showAddForm" class="card mb-4 p-4">
        <h6>New Trainer</h6>
        <div class="mb-2">
          <input class="form-control" v-model="newTrainer.name" placeholder="Name" />
        </div>
        <div class="mb-2">
          <input class="form-control" v-model="newTrainer.email" placeholder="Email" />
        </div>
        <div class="mb-2">
          <input class="form-control" type="password" v-model="newTrainer.password" placeholder="Password" />
        </div>
        <div class="mb-2">
          <input class="form-control" v-model="newTrainer.speciality" placeholder="Speciality" />
        </div>
        <div class="mb-2">
          <label class="form-label">Time Slots <small class="text-muted">(one per line)</small></label>
          <textarea class="form-control" v-model="newTrainer.timeSlotsRaw" rows="3" placeholder="e.g. Monday 08:00&#10;Tuesday 10:00"></textarea>
        </div>
        <div class="mb-2">
          <textarea class="form-control" v-model="editingTrainer.bio" placeholder="Bio" rows="3"></textarea>
        </div>
        <button class="btn btn-success" @click="addTrainer" :disabled="adding">
          {{ adding ? 'Adding...' : 'Add Trainer' }}
        </button>
        <div v-if="addError" class="alert alert-danger mt-2">{{ addError }}</div>
      </div>

      <!-- Trainers Table -->
      <table class="table table-bordered table-hover">
        <thead class="table-dark">
          <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Speciality</th>
            <th>Actions</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="trainer in trainers" :key="trainer.id">
            <td>{{ trainer.id }}</td>
            <td>{{ trainer.name }}</td>
            <td>{{ trainer.email }}</td>
            <td>{{ trainer.speciality }}</td>
            <td>
              <button class="btn btn-sm btn-warning me-2" @click="openEdit(trainer)">Edit</button>
              <button class="btn btn-sm btn-danger" @click="deleteTrainer(trainer.id)">Delete</button>
            </td>
          </tr>
        </tbody>
      </table>

      <!-- Edit Trainer Form -->
      <!-- Edit Trainer Form -->
      <div v-if="editingTrainer" class="card mt-4 p-4">
        <h6>Edit Trainer</h6>
          <div class="mb-2">
            <input class="form-control" v-model="editingTrainer.name" placeholder="Name" />
          </div>
        <div class="mb-2">
        <input class="form-control" v-model="editingTrainer.email" placeholder="Email" />
        </div>
        <div class="mb-2">
          <input class="form-control" v-model="editingTrainer.speciality" placeholder="Speciality" />
        </div>
        <div class="mb-2">
          <label class="form-label">Time Slots <small class="text-muted">(one per line)</small></label>
          <textarea class="form-control" v-model="editingTrainerSlotsRaw" rows="3"></textarea>
        </div>
        <div class="mb-2">
          <textarea class="form-control" v-model="editingTrainer.bio" placeholder="Bio" rows="3"></textarea>
        </div>
        <button class="btn btn-primary me-2" @click="saveTrainer">Save</button>
        <button class="btn btn-secondary" @click="editingTrainer = null">Cancel</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import axios from 'axios'
import { SessionManager } from '@/utils/session.manager'

const tab = ref('users')
const users = ref([])
const trainers = ref([])
const editingTrainer = ref(null)
const editingTrainerSlotsRaw = ref('')  // ← declare it
const showAddForm = ref(false)
const adding = ref(false)
const addError = ref('')

const newTrainer = ref({
  name: '',
  email: '',
  password: '',
  speciality: '',
  timeSlotsRaw: ''
})

const token = SessionManager.getAccessToken()
const authHeader = { headers: { Authorization: `Bearer ${token}` } }

const fetchUsers = async () => {
  const res = await axios.get('https://localhost:3000/api/users', authHeader)
  users.value = res.data.map((entry: any) => ({
    ...entry.user,
    trainers: entry.trainers
  }))
}

const fetchTrainers = async () => {
  const res = await axios.get('https://localhost:3000/api/trainer', authHeader)
  trainers.value = res.data
}

const addTrainer = async () => {
  addError.value = ''
  if (!newTrainer.value.name || !newTrainer.value.email || !newTrainer.value.password || !newTrainer.value.speciality) {
    addError.value = 'All fields are required.'
    return
  }
  try {
    adding.value = true
    const timeSlots = newTrainer.value.timeSlotsRaw
      .split('\n')
      .map(s => s.trim())
      .filter(s => s.length > 0)

    await axios.post('https://localhost:3000/api/trainer/signup', {
      name: newTrainer.value.name,
      email: newTrainer.value.email,
      password: newTrainer.value.password,
      speciality: newTrainer.value.speciality,
      timeSlots
    }, authHeader)

    newTrainer.value = { name: '', email: '', password: '', speciality: '', timeSlotsRaw: '' }
    showAddForm.value = false
    await fetchTrainers()
  } catch (e: any) {
    addError.value = e.response?.data?.message || 'Failed to add trainer.'
  } finally {
    adding.value = false
  }
}

const deleteUser = async (id: number) => {
  if (!confirm('Delete this user?')) return
  await axios.delete(`https://localhost:3000/api/users/admin/users/${id}`, authHeader)
  await fetchUsers()
}

const deleteTrainer = async (id: number) => {
  if (!confirm('Delete this trainer?')) return
  await axios.delete(`https://localhost:3000/api/trainer/admin/${id}`, authHeader)
  await fetchTrainers()
}

const openEdit = (trainer: any) => {
  editingTrainer.value = { ...trainer }
  // ← populate timeslots textarea
  editingTrainerSlotsRaw.value = trainer.timeSlots
    ?.map((ts: any) => ts.slot)
    .join('\n') || ''
}

const saveTrainer = async () => {
  const timeSlots = editingTrainerSlotsRaw.value
    .split('\n')
    .map((s: string) => s.trim())
    .filter((s: string) => s.length > 0)

  await axios.put(
    `https://localhost:3000/api/trainer/admin/${editingTrainer.value.id}`,
    { ...editingTrainer.value, timeSlots },  // ← include timeSlots
    authHeader
  )
  editingTrainer.value = null
  editingTrainerSlotsRaw.value = ''  // ← reset
  await fetchTrainers()
}

onMounted(() => {
  fetchUsers()
  fetchTrainers()
})
</script>