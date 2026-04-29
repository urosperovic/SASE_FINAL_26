<template>
  <div class="profile-page">

    <!-- Avatar + summary -->
    <div class="card row-card">
      <div class="avatar">{{ initials }}</div>
      <div>
        <div class="display-name">{{ infoForm.username || 'Username' }}</div>
        <div class="meta">{{ infoForm.email || 'email@example.com' }}</div>
      </div>
    </div>

    <!-- Account info -->
    <div class="card">
      <div class="section-label">Account info</div>

      <div class="field">
        <label for="username">Username</label>
        <input
          id="username"
          v-model="infoForm.username"
          type="text"
          :class="fieldClass(usernameState)"
          @input="validateUsername"
          autocomplete="username"
        />
        <span class="hint" :class="hintClass(usernameState)">{{ usernameHint }}</span>
      </div>

      <div class="field">
        <label for="email">Email</label>
        <input
          id="email"
          v-model="infoForm.email"
          type="email"
          :class="fieldClass(emailState)"
          @input="validateEmail"
          autocomplete="email"
        />
        <span class="hint" :class="hintClass(emailState)">{{ emailHint }}</span>
      </div>

      <button class="btn primary" @click="saveInfo">Save changes</button>
    </div>

    <!-- Change password -->
    <div class="card">
      <div class="section-label">Change password</div>

      <div class="field">
        <label for="cur-pw">Current password</label>
        <div class="pw-wrap">
          <input
            id="cur-pw"
            v-model="pwForm.current"
            :type="show.current ? 'text' : 'password'"
            placeholder="Enter current password"
          />
          <button class="toggle" @click="show.current = !show.current" tabindex="-1">
            {{ show.current ? 'hide' : 'show' }}
          </button>
        </div>
      </div>

      <div class="divider" />

      <div class="field">
        <label for="new-pw">New password</label>
        <div class="pw-wrap">
          <input
            id="new-pw"
            v-model="pwForm.newPw"
            :type="show.newPw ? 'text' : 'password'"
            :class="fieldClass(newPwState)"
            placeholder="At least 8 characters"
            @input="validateNewPw"
          />
          <button class="toggle" @click="show.newPw = !show.newPw" tabindex="-1">
            {{ show.newPw ? 'hide' : 'show' }}
          </button>
        </div>
        <div class="strength-bar">
          <div class="strength-fill" :style="{ width: strengthWidth, background: strengthColor }" />
        </div>
        <span class="hint" :style="{ color: strengthColor }">{{ strengthLabel }}</span>
      </div>

      <div class="field">
        <label for="conf-pw">Confirm new password</label>
        <div class="pw-wrap">
          <input
            id="conf-pw"
            v-model="pwForm.confirm"
            :type="show.confirm ? 'text' : 'password'"
            :class="fieldClass(confirmState)"
            placeholder="Repeat new password"
            @input="validateConfirm"
          />
          <button class="toggle" @click="show.confirm = !show.confirm" tabindex="-1">
            {{ show.confirm ? 'hide' : 'show' }}
          </button>
        </div>
        <span class="hint" :class="hintClass(confirmState)">{{ confirmHint }}</span>
      </div>

      <button class="btn primary" @click="savePassword">Update password</button>
    </div>

    <!-- Danger zone -->
    <div class="card danger-card">
      <div class="section-label danger-label">Danger zone</div>
      <p class="danger-text">Permanently delete your account and all associated data. This cannot be undone.</p>
      <button class="btn danger" @click="confirmDelete">Delete account</button>
    </div>

    <!-- Toast -->
    <transition name="toast">
      <div v-if="toastMsg" class="toast">{{ toastMsg }}</div>
    </transition>

  </div>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'

// ── State ─────────────────────────────────────────────────────────────────────

const infoForm = reactive({ username: 'janedoe', email: 'jane@example.com' })
const pwForm   = reactive({ current: '', newPw: '', confirm: '' })
const show     = reactive({ current: false, newPw: false, confirm: false })

const usernameState = ref('neutral')  // neutral | ok | error
const usernameHint  = ref('3–20 chars · letters, numbers, underscores')
const emailState    = ref('neutral')
const emailHint     = ref('')

const newPwState  = ref('neutral')
const confirmState = ref('neutral')
const confirmHint  = ref('')

const toastMsg = ref('')
let toastTimer = null

// ── Avatar initials ───────────────────────────────────────────────────────────

const initials = computed(() => {
  const u = infoForm.username.replace(/[^a-zA-Z]/g, ' ').trim().split(/\s+/)
  return u.length >= 2
    ? (u[0][0] + u[u.length - 1][0]).toUpperCase()
    : infoForm.username.slice(0, 2).toUpperCase()
})

// ── Validation ────────────────────────────────────────────────────────────────

function validateUsername() {
  const v = infoForm.username.trim()
  if (!v) {
    usernameState.value = 'neutral'
    usernameHint.value  = '3–20 chars · letters, numbers, underscores'
    return
  }
  if (/^[a-zA-Z0-9_]{3,20}$/.test(v)) {
    usernameState.value = 'ok'
    usernameHint.value  = 'Username looks good'
  } else {
    usernameState.value = 'error'
    usernameHint.value  = 'Only letters, numbers, underscores (3–20 chars)'
  }
}

function validateEmail() {
  const v = infoForm.email.trim()
  if (!v) { emailState.value = 'neutral'; emailHint.value = ''; return }
  if (/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v)) {
    emailState.value = 'ok'; emailHint.value = 'Valid email address'
  } else {
    emailState.value = 'error'; emailHint.value = 'Enter a valid email address'
  }
}

// ── Password strength ─────────────────────────────────────────────────────────

function getStrength(pw) {
  let s = 0
  if (pw.length >= 8)           s++
  if (pw.length >= 12)          s++
  if (/[A-Z]/.test(pw))         s++
  if (/[0-9]/.test(pw))         s++
  if (/[^A-Za-z0-9]/.test(pw))  s++
  return s
}

const strengthLevels = [
  { width: '20%', color: '#E24B4A', label: 'Very weak' },
  { width: '40%', color: '#BA7517', label: 'Weak' },
  { width: '60%', color: '#639922', label: 'Fair' },
  { width: '80%', color: '#1D9E75', label: 'Strong' },
  { width: '100%', color: '#0F6E56', label: 'Very strong' },
]

const strengthWidth = ref('0%')
const strengthColor = ref('transparent')
const strengthLabel = ref('')

function validateNewPw() {
  const v = pwForm.newPw
  if (!v) {
    strengthWidth.value = '0%'
    strengthColor.value = 'transparent'
    strengthLabel.value = ''
    newPwState.value    = 'neutral'
    return
  }
  const s   = getStrength(v)
  const lvl = strengthLevels[Math.min(Math.max(s - 1, 0), 4)]
  strengthWidth.value = lvl.width
  strengthColor.value = lvl.color
  strengthLabel.value = lvl.label
  newPwState.value    = s >= 2 ? 'ok' : 'error'
  validateConfirm()
}

function validateConfirm() {
  const v = pwForm.confirm
  if (!v) { confirmState.value = 'neutral'; confirmHint.value = ''; return }
  if (v === pwForm.newPw) {
    confirmState.value = 'ok';    confirmHint.value = 'Passwords match'
  } else {
    confirmState.value = 'error'; confirmHint.value = 'Passwords do not match'
  }
}

// ── Save actions ──────────────────────────────────────────────────────────────

function saveInfo() {
  validateUsername()
  validateEmail()
  if (usernameState.value !== 'ok') { showToast('Fix the username first'); return }
  if (emailState.value     !== 'ok') { showToast('Fix the email first');    return }
  // TODO: call your API here
  showToast('Account info saved')
}

function savePassword() {
  if (!pwForm.current)              { showToast('Enter your current password'); return }
  if (getStrength(pwForm.newPw) < 2){ showToast('Choose a stronger password');  return }
  if (pwForm.newPw !== pwForm.confirm){ showToast('Passwords do not match');     return }
  // TODO: call your API here
  pwForm.current = ''
  pwForm.newPw   = ''
  pwForm.confirm = ''
  strengthWidth.value = '0%'
  strengthLabel.value = ''
  confirmHint.value   = ''
  newPwState.value    = confirmState.value = 'neutral'
  showToast('Password updated successfully')
}

function confirmDelete() {
  if (window.confirm('Permanently delete your account? This cannot be undone.')) {
    // TODO: call your API here
    showToast('Account deleted')
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

function showToast(msg, dur = 2500) {
  toastMsg.value = msg
  clearTimeout(toastTimer)
  toastTimer = setTimeout(() => { toastMsg.value = '' }, dur)
}

function fieldClass(state) {
  return { 'input-ok': state === 'ok', 'input-error': state === 'error' }
}

function hintClass(state) {
  return { 'hint-ok': state === 'ok', 'hint-error': state === 'error' }
}
</script>

<style scoped>
.profile-page {
  max-width: 500px;
  padding: 2rem 0;
  font-family: inherit;
  position: relative;
}

/* Cards */
.card {
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  padding: 1.25rem 1.5rem;
  margin-bottom: 1rem;
}

.row-card {
  display: flex;
  align-items: center;
  gap: 16px;
}

/* Avatar */
.avatar {
  width: 60px;
  height: 60px;
  border-radius: 50%;
  background: #dbeafe;
  color: #1d4ed8;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 20px;
  font-weight: 500;
  flex-shrink: 0;
}

.display-name {
  font-size: 16px;
  font-weight: 500;
  color: #111827;
}

.meta {
  font-size: 13px;
  color: #9ca3af;
  margin-top: 2px;
}

/* Section label */
.section-label {
  font-size: 11px;
  font-weight: 500;
  letter-spacing: 0.07em;
  text-transform: uppercase;
  color: #9ca3af;
  margin-bottom: 1.1rem;
}

/* Fields */
.field {
  margin-bottom: 1rem;
}

.field:last-of-type {
  margin-bottom: 0;
}

.field label {
  display: block;
  font-size: 13px;
  color: #6b7280;
  margin-bottom: 5px;
}

.field input {
  width: 100%;
  padding: 9px 12px;
  font-size: 14px;
  font-family: inherit;
  background: #f9fafb;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  color: #111827;
  outline: none;
  transition: border-color 0.15s, box-shadow 0.15s;
}

.field input:focus {
  border-color: #6b7280;
  box-shadow: 0 0 0 3px rgba(107, 114, 128, 0.1);
}

.field input.input-ok    { border-color: #16a34a; }
.field input.input-error { border-color: #dc2626; }

/* Hint */
.hint {
  display: block;
  font-size: 12px;
  margin-top: 5px;
  color: #9ca3af;
}

.hint.hint-ok    { color: #16a34a; }
.hint.hint-error { color: #dc2626; }

/* Password row */
.pw-wrap {
  position: relative;
}

.pw-wrap input {
  padding-right: 48px;
}

.toggle {
  position: absolute;
  right: 10px;
  top: 50%;
  transform: translateY(-50%);
  background: none;
  border: none;
  cursor: pointer;
  font-size: 12px;
  color: #9ca3af;
  font-family: inherit;
  padding: 2px 4px;
}

.toggle:hover { color: #6b7280; }

/* Strength bar */
.strength-bar {
  height: 3px;
  background: #e5e7eb;
  border-radius: 2px;
  margin-top: 8px;
  overflow: hidden;
}

.strength-fill {
  height: 100%;
  border-radius: 2px;
  transition: width 0.3s, background 0.3s;
}

/* Divider */
.divider {
  height: 1px;
  background: #f3f4f6;
  margin: 1rem 0;
}

/* Buttons */
.btn {
  width: 100%;
  padding: 10px;
  font-size: 14px;
  font-weight: 500;
  font-family: inherit;
  border-radius: 8px;
  cursor: pointer;
  transition: opacity 0.15s, background 0.15s;
  margin-top: 1.25rem;
}

.btn.primary {
  background: #111827;
  color: #fff;
  border: none;
}

.btn.primary:hover { opacity: 0.85; }

.btn.danger {
  background: transparent;
  color: #dc2626;
  border: 1px solid #fca5a5;
}

.btn.danger:hover { background: #fef2f2; }

/* Danger card */
.danger-card { border-color: #fca5a5; }
.danger-label { color: #dc2626; }
.danger-text { font-size: 13px; color: #6b7280; line-height: 1.6; margin-bottom: 0; }

/* Toast */
.toast {
  position: fixed;
  bottom: 1.5rem;
  left: 50%;
  transform: translateX(-50%);
  background: #111827;
  color: #fff;
  font-size: 13px;
  padding: 9px 18px;
  border-radius: 8px;
  white-space: nowrap;
  pointer-events: none;
  z-index: 999;
}

.toast-enter-active, .toast-leave-active { transition: opacity 0.2s, transform 0.2s; }
.toast-enter-from  { opacity: 0; transform: translateX(-50%) translateY(10px); }
.toast-leave-to    { opacity: 0; transform: translateX(-50%) translateY(10px); }

/* Dark mode */
@media (prefers-color-scheme: dark) {
  .card           { background: #1f2937; border-color: #374151; }
  .display-name   { color: #f9fafb; }
  .field input    { background: #111827; border-color: #374151; color: #f9fafb; }
  .field input:focus { border-color: #6b7280; }
  .divider        { background: #374151; }
  .btn.primary    { background: #f9fafb; color: #111827; }
  .strength-bar   { background: #374151; }
  .toast          { background: #f9fafb; color: #111827; }
}
</style>