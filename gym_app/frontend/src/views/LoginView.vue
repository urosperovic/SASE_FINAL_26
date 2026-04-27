<script setup lang="ts">
import { useRouter } from 'vue-router';
import { ref } from 'vue';
import { UserService } from '@/services/user.service';
import { SessionManager } from '@/utils/session.manager';

const email = ref('');
const password = ref('');
const router = useRouter();

function login() {
  UserService.login(email.value, password.value)
    .then(rsp => {
      if (rsp && rsp.data) {
        SessionManager.saveAuth(rsp.data);
        router.push({ path: '/' });
      }
    })
    .catch(e => {
      console.error('Login failed:', e);
      alert('Login failed. Please try again.');
    });
}

function goToSignup() {
  router.push({ path: '/signup' });
}
</script>

<template>
  <div class="auth-page">
    <div class="auth-left">
      <div class="auth-brand">
        <span class="brand-icon">⚡</span>
        <span class="brand-name">IRONFORGE</span>
      </div>
      <div class="auth-hero">
        <h1 class="hero-title">PUSH<br/>YOUR<br/>LIMITS</h1>
        <p class="hero-sub">Elite trainers. Real results. No excuses.</p>
      </div>
      <div class="auth-stats">
        <div class="stat"><span class="stat-num">240+</span><span class="stat-label">Trainers</span></div>
        <div class="stat"><span class="stat-num">12K</span><span class="stat-label">Members</span></div>
        <div class="stat"><span class="stat-num">98%</span><span class="stat-label">Satisfaction</span></div>
      </div>
    </div>

    <div class="auth-right">
      <div class="auth-form-wrap">
        <h2 class="form-title">Welcome Back</h2>
        <p class="form-sub">Sign in to continue your journey</p>

        <form @submit.prevent="login" class="auth-form">
          <div class="field-group">
            <label>Email Address</label>
            <input type="email" v-model="email" placeholder="you@example.com" required />
          </div>
          <div class="field-group">
            <label>Password</label>
            <input type="password" v-model="password" placeholder="••••••••" required />
          </div>
          <button type="submit" class="btn-main">Sign In</button>
        </form>

        <div class="divider"><span>or</span></div>

        <a href="https://localhost:3000/api/auth/google" class="btn-google">
          <img src="https://developers.google.com/identity/images/g-logo.png" width="20" />
          Continue with Google
        </a>

        <p class="form-footer">
          Don't have an account?
          <span @click="goToSignup">Create one</span>
        </p>
      </div>
    </div>
  </div>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@700;900&family=DM+Sans:wght@400;500&display=swap');

.auth-page {
  display: flex;
  min-height: 100vh;
  background: #0a0a0a;
  font-family: 'DM Sans', sans-serif;
}

.auth-left {
  flex: 1;
  background: linear-gradient(160deg, #111 0%, #1a1a1a 100%);
  padding: 3rem;
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  position: relative;
  overflow: hidden;
}

.auth-left::before {
  content: 'FIT';
  position: absolute;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 20rem;
  font-weight: 900;
  color: rgba(255,255,255,0.02);
  bottom: -3rem;
  left: -2rem;
  line-height: 1;
  pointer-events: none;
}

.auth-brand {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  font-family: 'Barlow Condensed', sans-serif;
  font-weight: 900;
  font-size: 1.4rem;
  color: #fff;
  letter-spacing: 2px;
}

.brand-icon { font-size: 1.6rem; }

.hero-title {
  font-family: 'Barlow Condensed', sans-serif;
  font-weight: 900;
  font-size: 7rem;
  line-height: 0.9;
  color: #fff;
  letter-spacing: -2px;
}

.hero-sub {
  color: #888;
  font-size: 1rem;
  margin-top: 1.5rem;
  letter-spacing: 1px;
  text-transform: uppercase;
  font-size: 0.85rem;
}

.auth-stats {
  display: flex;
  gap: 2.5rem;
}

.stat { display: flex; flex-direction: column; }
.stat-num {
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 2.2rem;
  font-weight: 700;
  color: #e8ff00;
  line-height: 1;
}
.stat-label { font-size: 0.75rem; color: #666; text-transform: uppercase; letter-spacing: 1px; margin-top: 0.25rem; }

.auth-right {
  width: 480px;
  background: #fff;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 3rem;
}

.auth-form-wrap { width: 100%; max-width: 360px; }

.form-title {
  font-family: 'Barlow Condensed', sans-serif;
  font-weight: 900;
  font-size: 2.8rem;
  color: #0a0a0a;
  line-height: 1;
  margin-bottom: 0.5rem;
}

.form-sub { color: #888; font-size: 0.9rem; margin-bottom: 2rem; }

.auth-form { display: flex; flex-direction: column; gap: 1.25rem; }

.field-group { display: flex; flex-direction: column; gap: 0.4rem; }
.field-group label { font-size: 0.8rem; font-weight: 500; color: #444; text-transform: uppercase; letter-spacing: 0.5px; }
.field-group input {
  padding: 0.85rem 1rem;
  border: 2px solid #e8e8e8;
  border-radius: 8px;
  font-size: 0.95rem;
  font-family: 'DM Sans', sans-serif;
  transition: border-color 0.2s;
  outline: none;
}
.field-group input:focus { border-color: #0a0a0a; }

.btn-main {
  background: #0a0a0a;
  color: #e8ff00;
  border: none;
  padding: 1rem;
  border-radius: 8px;
  font-family: 'Barlow Condensed', sans-serif;
  font-weight: 700;
  font-size: 1.1rem;
  letter-spacing: 2px;
  text-transform: uppercase;
  cursor: pointer;
  transition: background 0.2s, transform 0.1s;
  margin-top: 0.5rem;
}
.btn-main:hover { background: #222; transform: translateY(-1px); }

.divider {
  text-align: center;
  margin: 1.5rem 0;
  position: relative;
  color: #ccc;
  font-size: 0.8rem;
}
.divider::before {
  content: '';
  position: absolute;
  top: 50%;
  left: 0; right: 0;
  height: 1px;
  background: #eee;
}
.divider span { background: #fff; padding: 0 1rem; position: relative; }

.btn-google {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0.75rem;
  padding: 0.85rem;
  border: 2px solid #e8e8e8;
  border-radius: 8px;
  font-size: 0.9rem;
  font-weight: 500;
  color: #333;
  text-decoration: none;
  transition: border-color 0.2s, background 0.2s;
}
.btn-google:hover { border-color: #ccc; background: #fafafa; }

.form-footer {
  text-align: center;
  margin-top: 1.5rem;
  font-size: 0.85rem;
  color: #888;
}
.form-footer span { color: #0a0a0a; font-weight: 600; cursor: pointer; text-decoration: underline; }

@media (max-width: 768px) {
  .auth-left { display: none; }
  .auth-right { width: 100%; }
}
</style>