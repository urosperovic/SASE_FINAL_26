<template>
  <div class="profile-page">

    <!-- Header -->
    <div class="profile-header">
      <p class="eyebrow">⚡ IRONFORGE</p>
      <h1 class="page-title">My Profile</h1>
    </div>

    <div class="profile-body">

      <!-- Avatar + hero card -->
      <div class="hero-card">
        <div class="avatar-wrap">
          <div class="avatar">{{ initials }}</div>
          <div class="avatar-ring"></div>
        </div>
        <div class="hero-info">
          <div class="hero-name">{{ infoForm.username || 'Username' }}</div>
          <div class="hero-email">{{ infoForm.email || 'email@example.com' }}</div>
          <span class="hero-badge">{{ userRole }}</span>
        </div>
      </div>
    </div>

    <!-- Toast -->
    <transition name="toast">
      <div v-if="toastMsg" class="toast" :class="toastType">{{ toastMsg }}</div>
    </transition>

  </div>
</template>

<script setup lang="ts">
import { ref, reactive, computed, onMounted } from 'vue'
import axios from 'axios'
import { SessionManager } from '@/utils/session.manager'

// ── State ──────────────────────────────────────────────────────────────────────
const infoForm = reactive({ username: '', email: '' })
const userRole    = ref('member')
const toastMsg  = ref('')
const toastType = ref('') // '' | 'success' | 'error'
let toastTimer: ReturnType<typeof setTimeout> | null = null

// ── Token ──────────────────────────────────────────────────────────────────────

const token     = SessionManager.getAccessToken()
const authHeader = { headers: { Authorization: `Bearer ${token}` } }

// ── Computed ──────────────────────────────────────────────────────────────────

const initials = computed(() => {
  const u = infoForm.username.replace(/[^a-zA-Z]/g, ' ').trim().split(/\s+/)
  return u.length >= 2
    ? (u[0][0] + u[u.length - 1][0]).toUpperCase()
    : infoForm.username.slice(0, 2).toUpperCase() || 'IF'
})

// ── Fetch profile ─────────────────────────────────────────────────────────────

const fetchProfile = async () => {
  try {
    const res = await axios.get('https://localhost:3000/api/users/me', authHeader)
    const data = res.data
    infoForm.username = data.user?.name  || data.name  || ''
    infoForm.email    = data.user?.email || data.email || ''
    userRole.value    = data.user?.role  || data.role  || 'member'
  } catch (e) {
    showToast('Failed to load profile', 'error')
  }
}


// ── Helpers ───────────────────────────────────────────────────────────────────

function showToast(msg: string, type: string = '', dur = 2800) {
  toastMsg.value  = msg
  toastType.value = type
  if (toastTimer) clearTimeout(toastTimer)
  toastTimer = setTimeout(() => { toastMsg.value = '' }, dur)
}

// ── Mount ─────────────────────────────────────────────────────────────────────

onMounted(fetchProfile)
</script>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@700;900&family=DM+Sans:wght@400;500&display=swap');

/* ─── Base ────────────────────────────────────────────────── */
.profile-page {
  min-height: 100vh;
  background: #0f0f0f;
  font-family: 'DM Sans', sans-serif;
  color: #fff;
  position: relative;
}

/* ─── Header ─────────────────────────────────────────────── */
.profile-header {
  background: #111;
  border-bottom: 1px solid #222;
  padding: 2rem 3rem;
}

.eyebrow {
  color: #e8ff00;
  font-size: 0.75rem;
  letter-spacing: 3px;
  text-transform: uppercase;
  margin: 0 0 0.25rem;
}

.page-title {
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 3rem;
  font-weight: 900;
  margin: 0;
}

/* ─── Body ───────────────────────────────────────────────── */
.profile-body {
  padding: 2rem 3rem;
  max-width: 1200px;
}

/* ─── Hero card ──────────────────────────────────────────── */
.hero-card {
  background: #141414;
  border: 1px solid #222;
  border-radius: 14px;
  padding: 1.75rem 2rem;
  display: flex;
  align-items: center;
  gap: 1.75rem;
  margin-bottom: 1.75rem;
  position: relative;
  overflow: hidden;
}

.hero-card::before {
  content: '';
  position: absolute;
  top: 0; left: 0; right: 0;
  height: 3px;
  background: linear-gradient(90deg, #e8ff00, transparent);
}

.avatar-wrap {
  position: relative;
  flex-shrink: 0;
}

.avatar {
  width: 72px;
  height: 72px;
  border-radius: 50%;
  background: #e8ff00;
  color: #0a0a0a;
  display: flex;
  align-items: center;
  justify-content: center;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 1.75rem;
  font-weight: 900;
  z-index: 1;
  position: relative;
}

.avatar-ring {
  position: absolute;
  inset: -4px;
  border-radius: 50%;
  border: 2px solid #e8ff00;
  opacity: 0.3;
}

.hero-info {
  flex: 1;
}

.hero-name {
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 2rem;
  font-weight: 900;
  color: #fff;
  line-height: 1;
}

.hero-email {
  font-size: 0.875rem;
  color: #555;
  margin-top: 0.3rem;
}

.hero-badge {
  display: inline-block;
  margin-top: 0.5rem;
  font-size: 0.65rem;
  text-transform: uppercase;
  letter-spacing: 1.5px;
  padding: 0.2rem 0.6rem;
  background: rgba(232, 255, 0, 0.1);
  color: #e8ff00;
  border: 1px solid rgba(232, 255, 0, 0.25);
  border-radius: 4px;
  font-weight: 700;
}


/* ─── Responsive ─────────────────────────────────────────── */
@media (max-width: 900px) {
  .profile-body   { padding: 1.5rem; }
  .profile-header { padding: 1.5rem; }
  .two-col        { grid-template-columns: 1fr; }
  .hero-stats     { display: none; }
}

@media (max-width: 600px) {
  .profile-header { padding: 1rem 1.25rem; }
  .profile-body   { padding: 1rem 1.25rem; }
  .page-title     { font-size: 2.25rem; }
  .hero-card      { flex-direction: column; align-items: flex-start; gap: 1rem; }
  .activity-grid  { grid-template-columns: 1fr; }
}
</style>