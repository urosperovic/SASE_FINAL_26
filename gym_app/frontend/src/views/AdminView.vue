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

    <!-- Trainers Table -->
    <div v-if="tab === 'trainers'">
      <h5>All Trainers</h5>
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

const token = SessionManager.getAccessToken()
const authHeader = { headers: { Authorization: `Bearer ${token}` } }

const fetchUsers = async () => {
  const res = await axios.get('https://localhost:3000/api/users', authHeader)
  // API returns { user, trainers }[] — unwrap to flat user objects
  users.value = res.data.map((entry: any) => ({
    ...entry.user,
    trainers: entry.trainers
  }))
}

const fetchTrainers = async () => {
  const res = await axios.get('https://localhost:3000/api/trainer', authHeader)
  trainers.value = res.data
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
}

const saveTrainer = async () => {
  await axios.put(`https://localhost:3000/api/trainer/admin/${editingTrainer.value.id}`, editingTrainer.value, authHeader)
  editingTrainer.value = null
  await fetchTrainers()
}

onMounted(() => {
  fetchUsers()
  fetchTrainers()
})
</script>