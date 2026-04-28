<template>
  <div class="admin-page">
    <div class="admin-header">
      <div>
        <p class="admin-eyebrow">⚡ IRONFORGE</p>
        <h1 class="admin-title">Admin Panel</h1>
      </div>
    </div>

    <div class="admin-body">
      <!-- Tabs -->
      <div class="admin-tabs">
        <button :class="['tab-btn', { active: tab === 'users' }]" @click="tab = 'users'">Users</button>
        <button :class="['tab-btn', { active: tab === 'trainers' }]" @click="tab = 'trainers'">Trainers</button>
      </div>

      <!-- Users -->
      <div v-if="tab === 'users'">
        <div class="table-top">
          <h2 class="table-heading">All Users</h2>
          <div class="btn-group-right">
            <button class="btn-export" @click="exportUsers">⬇ Users</button>
            <button class="btn-export" @click="exportBookings">⬇ Bookings</button>
          </div>
        </div>
        <div class="admin-table-wrap">
          <table class="admin-table">
            <thead>
              <tr>
                <th>ID</th><th>Name</th><th>Email</th><th>Role</th><th>Actions</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="user in users" :key="user.id">
                <td class="id-col">{{ user.id }}</td>
                <td>{{ user.name }}</td>
                <td class="email-col">{{ user.email }}</td>
                <td><span :class="['role-badge', user.role === 'admin' ? 'admin' : 'user']">{{ user.role }}</span></td>
                <td><button class="btn-del" @click="deleteUser(user.id)">Delete</button></td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>

      <!-- Trainers -->
      <div v-if="tab === 'trainers'">
        <div class="table-top">
          <h2 class="table-heading">All Trainers</h2>
          <div class="btn-group-right">
            <button class="btn-export" @click="exportTrainers">⬇ Trainers</button>
            <button class="btn-add" @click="showAddForm = !showAddForm">
              {{ showAddForm ? '✕ Cancel' : '+ Add Trainer' }}
            </button>
          </div>
        </div>

        <!-- Add Form -->
        <div v-if="showAddForm" class="admin-form-card">
          <h3 class="form-card-title">New Trainer</h3>
          <div class="form-grid">
            <div class="field-group"><label>Name</label><input v-model="newTrainer.name" placeholder="Full name" /></div>
            <div class="field-group"><label>Email</label><input v-model="newTrainer.email" placeholder="email@gym.com" /></div>
            <div class="field-group"><label>Password</label><input type="password" v-model="newTrainer.password" placeholder="••••••••" /></div>
            <div class="field-group"><label>Speciality</label><input v-model="newTrainer.speciality" placeholder="e.g. Strength & Conditioning" /></div>
          </div>
          <div class="field-group full">
            <label>Bio</label>
            <textarea v-model="newTrainer.bio" placeholder="Trainer biography..." rows="3"></textarea>
          </div>
          <div class="field-group full">
            <label>Time Slots <span class="label-hint">(one per line)</span></label>
            <textarea v-model="newTrainer.timeSlotsRaw" rows="3" placeholder="Monday 08:00&#10;Tuesday 10:00"></textarea>
          </div>
          <button class="btn-submit" @click="addTrainer" :disabled="adding">{{ adding ? 'Adding...' : 'Add Trainer' }}</button>
          <div v-if="addError" class="error-msg">{{ addError }}</div>
        </div>

        <!-- Table -->
        <div class="admin-table-wrap">
          <table class="admin-table">
            <thead>
              <tr><th>ID</th><th>Name</th><th>Email</th><th>Speciality</th><th>Actions</th></tr>
            </thead>
            <tbody>
              <tr v-for="trainer in trainers" :key="trainer.id">
                <td class="id-col">{{ trainer.id }}</td>
                <td>{{ trainer.name }}</td>
                <td class="email-col">{{ trainer.email }}</td>
                <td>{{ trainer.speciality }}</td>
                <td>
                  <button class="btn-edit" @click="openEdit(trainer)">Edit</button>
                  <button class="btn-del" @click="deleteTrainer(trainer.id)">Delete</button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- Edit Form -->
        <div v-if="editingTrainer" class="admin-form-card mt">
          <h3 class="form-card-title">Edit Trainer</h3>
          <div class="form-grid">
            <div class="field-group"><label>Name</label><input v-model="editingTrainer.name" /></div>
            <div class="field-group"><label>Email</label><input v-model="editingTrainer.email" /></div>
            <div class="field-group"><label>Speciality</label><input v-model="editingTrainer.speciality" /></div>
          </div>
          <div class="field-group full">
            <label>Bio</label>
            <textarea v-model="editingTrainer.bio" rows="3" placeholder="Trainer biography..."></textarea>
          </div>
          <div class="field-group full">
            <label>Time Slots <span class="label-hint">(one per line)</span></label>
            <textarea v-model="editingTrainerSlotsRaw" rows="3"></textarea>
          </div>
          <div class="form-actions">
            <button class="btn-submit" @click="saveTrainer">Save Changes</button>
            <button class="btn-cancel" @click="editingTrainer = null">Cancel</button>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue'
import axios from 'axios'
import * as XLSX from 'xlsx'
import { SessionManager } from '@/utils/session.manager'

const tab = ref('users')
const users = ref([])
const trainers = ref([])
const editingTrainer = ref(null)
const editingTrainerSlotsRaw = ref('')
const showAddForm = ref(false)
const adding = ref(false)
const addError = ref('')

const newTrainer = ref({ name: '', email: '', password: '', speciality: '', bio: '', timeSlotsRaw: '' })

const token = SessionManager.getAccessToken()
const authHeader = { headers: { Authorization: `Bearer ${token}` } }

const today = () => new Date().toISOString().split('T')[0]

// ─── Fetch ────────────────────────────────────────────────
const fetchUsers = async () => {
  const res = await axios.get('https://localhost:3000/api/users', authHeader)
  users.value = res.data.map((e: any) => ({ ...e.user, trainers: e.trainers }))
}

const fetchTrainers = async () => {
  const res = await axios.get('https://localhost:3000/api/trainer', authHeader)
  trainers.value = res.data
}

// ─── Export ───────────────────────────────────────────────
const exportUsers = () => {
  const data = users.value.map((u: any) => ({
    ID: u.id,
    Name: u.name,
    Email: u.email,
    Role: u.role
  }))
  const ws = XLSX.utils.json_to_sheet(data)
  ws['!cols'] = [{ wch: 6 }, { wch: 20 }, { wch: 30 }, { wch: 10 }]
  const wb = XLSX.utils.book_new()
  XLSX.utils.book_append_sheet(wb, ws, 'Users')
  XLSX.writeFile(wb, `ironforge_users_${today()}.xlsx`)
}

const exportTrainers = () => {
  const data = trainers.value.map((t: any) => ({
    ID: t.id,
    Name: t.name,
    Email: t.email,
    Speciality: t.speciality,
    Bio: t.bio || '',
    'Time Slots': t.timeSlots?.map((s: any) => s.slot).join(', ') || ''
  }))
  const ws = XLSX.utils.json_to_sheet(data)
  ws['!cols'] = [{ wch: 6 }, { wch: 20 }, { wch: 30 }, { wch: 20 }, { wch: 40 }, { wch: 40 }]
  const wb = XLSX.utils.book_new()
  XLSX.utils.book_append_sheet(wb, ws, 'Trainers')
  XLSX.writeFile(wb, `ironforge_trainers_${today()}.xlsx`)
}

const exportBookings = () => {
  const data: any[] = []
  users.value.forEach((u: any) => {
    if (u.trainers?.length > 0) {
      u.trainers.forEach((b: any) => {
        data.push({
          'User ID': u.id,
          'User Name': u.name,
          'User Email': u.email,
          'Trainer ID': b.trainer_id,
          'Time Slot ID': b.timeSlot_id
        })
      })
    }
  })
  if (data.length === 0) {
    alert('No bookings found to export.')
    return
  }
  const ws = XLSX.utils.json_to_sheet(data)
  ws['!cols'] = [{ wch: 8 }, { wch: 20 }, { wch: 30 }, { wch: 10 }, { wch: 12 }]
  const wb = XLSX.utils.book_new()
  XLSX.utils.book_append_sheet(wb, ws, 'Bookings')
  XLSX.writeFile(wb, `ironforge_bookings_${today()}.xlsx`)
}

// ─── CRUD ─────────────────────────────────────────────────
const addTrainer = async () => {
  addError.value = ''
  if (!newTrainer.value.name || !newTrainer.value.email || !newTrainer.value.password || !newTrainer.value.speciality) {
    addError.value = 'All fields are required.'
    return
  }
  try {
    adding.value = true
    const timeSlots = newTrainer.value.timeSlotsRaw.split('\n').map(s => s.trim()).filter(s => s.length > 0)
    await axios.post('https://localhost:3000/api/trainer/signup', {
      name: newTrainer.value.name, email: newTrainer.value.email,
      password: newTrainer.value.password, speciality: newTrainer.value.speciality,
      bio: newTrainer.value.bio, timeSlots
    }, authHeader)
    newTrainer.value = { name: '', email: '', password: '', speciality: '', bio: '', timeSlotsRaw: '' }
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
  editingTrainerSlotsRaw.value = trainer.timeSlots?.map((ts: any) => ts.slot).join('\n') || ''
}

const saveTrainer = async () => {
  const timeSlots = editingTrainerSlotsRaw.value.split('\n').map((s: string) => s.trim()).filter((s: string) => s.length > 0)
  await axios.put(`https://localhost:3000/api/trainer/admin/${editingTrainer.value.id}`, { ...editingTrainer.value, timeSlots }, authHeader)
  editingTrainer.value = null
  editingTrainerSlotsRaw.value = ''
  await fetchTrainers()
}

onMounted(() => { fetchUsers(); fetchTrainers() })
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@700;900&family=DM+Sans:wght@400;500&display=swap');

.admin-page { min-height: 100vh; background: #0f0f0f; font-family: 'DM Sans', sans-serif; color: #fff; }

.admin-header { background: #111; border-bottom: 1px solid #222; padding: 2rem 3rem; }
.admin-eyebrow { color: #e8ff00; font-size: 0.75rem; letter-spacing: 3px; text-transform: uppercase; margin: 0 0 0.25rem; }
.admin-title { font-family: 'Barlow Condensed', sans-serif; font-size: 3rem; font-weight: 900; margin: 0; }

.admin-body { padding: 2rem 3rem; }

.admin-tabs { display: flex; gap: 0.5rem; margin-bottom: 2rem; border-bottom: 1px solid #222; }
.tab-btn { background: none; border: none; color: #555; font-family: 'Barlow Condensed', sans-serif; font-size: 1.1rem; font-weight: 700; letter-spacing: 1px; text-transform: uppercase; padding: 0.75rem 1.5rem; cursor: pointer; border-bottom: 2px solid transparent; transition: all 0.2s; margin-bottom: -1px; }
.tab-btn.active { color: #e8ff00; border-bottom-color: #e8ff00; }
.tab-btn:hover { color: #fff; }

.table-top { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.25rem; }
.table-heading { font-family: 'Barlow Condensed', sans-serif; font-size: 1.5rem; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; margin: 0; color: #fff; }

.btn-group-right { display: flex; gap: 0.5rem; align-items: center; }

.btn-export {
  background: #1a1a1a;
  border: 1px solid #e8ff00;
  color: #e8ff00;
  padding: 0.6rem 1.1rem;
  border-radius: 6px;
  font-family: 'Barlow Condensed', sans-serif;
  font-weight: 700; font-size: 0.9rem; letter-spacing: 1px;
  cursor: pointer; transition: background 0.2s;
}
.btn-export:hover { background: rgba(232,255,0,0.1); }

.btn-add { background: #e8ff00; color: #0a0a0a; border: none; padding: 0.6rem 1.25rem; border-radius: 6px; font-family: 'Barlow Condensed', sans-serif; font-weight: 700; font-size: 0.95rem; letter-spacing: 1px; cursor: pointer; transition: opacity 0.2s; }
.btn-add:hover { opacity: 0.85; }

.admin-table-wrap { border-radius: 10px; overflow: hidden; border: 1px solid #222; margin-bottom: 1.5rem; }
.admin-table { width: 100%; border-collapse: collapse; }
.admin-table thead { background: #1a1a1a; }
.admin-table th { padding: 0.85rem 1rem; text-align: left; font-size: 0.7rem; text-transform: uppercase; letter-spacing: 1.5px; color: #555; font-weight: 500; }
.admin-table td { padding: 0.85rem 1rem; border-top: 1px solid #1e1e1e; font-size: 0.9rem; color: #ccc; vertical-align: middle; }
.admin-table tbody tr { background: #111; transition: background 0.15s; }
.admin-table tbody tr:hover { background: #161616; }
.id-col { color: #444; font-size: 0.8rem; }
.email-col { color: #888; }

.role-badge { font-size: 0.7rem; padding: 0.2rem 0.6rem; border-radius: 4px; text-transform: uppercase; letter-spacing: 1px; font-weight: 700; }
.role-badge.admin { background: rgba(232,255,0,0.15); color: #e8ff00; }
.role-badge.user { background: #222; color: #666; }

.btn-edit { background: #1e1e1e; border: 1px solid #333; color: #fff; padding: 0.35rem 0.8rem; border-radius: 5px; font-size: 0.8rem; cursor: pointer; margin-right: 0.4rem; transition: background 0.2s; }
.btn-edit:hover { background: #2a2a2a; }
.btn-del { background: rgba(255,68,68,0.1); border: 1px solid rgba(255,68,68,0.3); color: #ff4444; padding: 0.35rem 0.8rem; border-radius: 5px; font-size: 0.8rem; cursor: pointer; transition: background 0.2s; }
.btn-del:hover { background: rgba(255,68,68,0.2); }

.admin-form-card { background: #141414; border: 1px solid #222; border-radius: 12px; padding: 1.75rem; margin-bottom: 1.5rem; }
.admin-form-card.mt { margin-top: 1.5rem; }
.form-card-title { font-family: 'Barlow Condensed', sans-serif; font-size: 1.3rem; font-weight: 700; text-transform: uppercase; letter-spacing: 1px; margin: 0 0 1.25rem; color: #fff; }

.form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem; }

.field-group { display: flex; flex-direction: column; gap: 0.4rem; }
.field-group.full { margin-bottom: 1rem; }
.field-group label { font-size: 0.75rem; text-transform: uppercase; letter-spacing: 1px; color: #555; font-weight: 500; }
.label-hint { font-size: 0.7rem; color: #444; text-transform: none; letter-spacing: 0; }
.field-group input, .field-group textarea { background: #1a1a1a; border: 1px solid #2a2a2a; color: #fff; padding: 0.7rem 0.9rem; border-radius: 7px; font-size: 0.9rem; font-family: 'DM Sans', sans-serif; outline: none; transition: border-color 0.2s; resize: vertical; }
.field-group input:focus, .field-group textarea:focus { border-color: #e8ff00; }
.field-group input::placeholder, .field-group textarea::placeholder { color: #444; }

.form-actions { display: flex; gap: 0.75rem; margin-top: 0.5rem; }
.btn-submit { background: #e8ff00; color: #0a0a0a; border: none; padding: 0.75rem 1.5rem; border-radius: 7px; font-family: 'Barlow Condensed', sans-serif; font-weight: 700; font-size: 1rem; letter-spacing: 1px; cursor: pointer; transition: opacity 0.2s; }
.btn-submit:hover { opacity: 0.85; }
.btn-submit:disabled { opacity: 0.5; cursor: not-allowed; }
.btn-cancel { background: #1e1e1e; border: 1px solid #333; color: #888; padding: 0.75rem 1.5rem; border-radius: 7px; font-size: 0.9rem; cursor: pointer; transition: background 0.2s; }
.btn-cancel:hover { background: #2a2a2a; color: #fff; }

.error-msg { background: rgba(255,68,68,0.1); border: 1px solid rgba(255,68,68,0.3); color: #ff4444; padding: 0.75rem 1rem; border-radius: 6px; font-size: 0.85rem; margin-top: 0.75rem; }
</style>