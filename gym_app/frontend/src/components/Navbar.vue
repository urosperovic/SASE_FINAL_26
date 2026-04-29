<script setup lang="ts">
import { useRouter, useRoute } from 'vue-router';
import { SessionManager } from '../utils/session.manager';
import { useLogout } from '../utils/logout.hook';
import { computed } from 'vue'

const router = useRouter();
const route = useRoute();

function goToLogin() {
  router.push('/login');
}

const logout = useLogout();
//const isAuthenticated = () => SessionManager.hasAuth();

const isAuthenticated = computed(() => {
  route.path
  return SessionManager.hasAuth()
})

</script>

<template>
  <nav class="navbar">
    <div class="navbar-inner">
      <router-link to="/" class="navbar-brand">
        <img
          src="https://marketplace.canva.com/EAFR5zOv2_c/2/0/1600w/canva-green-modern-fitness-app-logo-sE0Hizm2VsU.jpg"
          alt="Logo"
          class="brand-logo"
        />
        <span class="brand-name">IRONFORGE</span>
      </router-link>

      <div class="navbar-actions">
        <template v-if="isAuthenticated">
          <button class="nav-btn btn-ghost" @click="$router.push('/exercises')">
            <span class="btn-label">Exercise Alone</span>
          </button>
          <button class="nav-btn btn-accent" @click="$router.push('/selected')">
            <span class="btn-label">My Trainers</span>
          </button>
          <button class="nav-btn btn-accent" @click="$router.push('/profile')">
            <span class="btn-label">My Profile</span>
          </button>
          <button class="nav-btn btn-danger" @click="logout">
            <span class="btn-label">Logout</span>
          </button>
        </template>
        <template v-else>
          <button class="nav-btn btn-accent" @click="goToLogin">
            <span class="btn-label">Login</span>
          </button>
        </template>
      </div>
    </div>
  </nav>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@700;900&family=DM+Sans:wght@400;500&display=swap');

.navbar {
  background: #0a0a0a;
  border-bottom: 1px solid #222;
  position: sticky;
  top: 0;
  z-index: 100;
  font-family: 'DM Sans', sans-serif;
}

.navbar-inner {
  max-width: 1400px;
  margin: 0 auto;
  padding: 0 2.5rem;
  height: 64px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.navbar-brand {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  text-decoration: none;
}

.brand-logo {
  width: 36px;
  height: 36px;
  border-radius: 6px;
  object-fit: cover;
  border: 1px solid #2a2a2a;
}

.brand-name {
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 1.3rem;
  font-weight: 900;
  letter-spacing: 3px;
  color: #e8ff00;
  text-transform: uppercase;
}

.navbar-actions {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.nav-btn {
  font-family: 'Barlow Condensed', sans-serif;
  font-weight: 700;
  font-size: 0.85rem;
  letter-spacing: 1.5px;
  text-transform: uppercase;
  padding: 0.45rem 1.1rem;
  border-radius: 6px;
  border: 1px solid transparent;
  cursor: pointer;
  transition: all 0.18s ease;
}

.btn-ghost {
  background: transparent;
  border-color: #2a2a2a;
  color: #aaa;
}
.btn-ghost:hover {
  border-color: #e8ff00;
  color: #e8ff00;
}

.btn-accent {
  background: #e8ff00;
  color: #0a0a0a;
  border-color: #e8ff00;
}
.btn-accent:hover {
  opacity: 0.85;
}

.btn-danger {
  background: transparent;
  border-color: #333;
  color: #666;
}
.btn-danger:hover {
  border-color: #ff4444;
  color: #ff4444;
}
@media (max-width: 768px) {
  .navbar-inner {
    padding: 0 1.25rem;
    height: 56px;
  }

  .brand-name {
    font-size: 1rem;
    letter-spacing: 2px;
  }

  .brand-logo {
    width: 28px;
    height: 28px;
  }

  .nav-btn {
    font-size: 0.75rem;
    padding: 0.35rem 0.7rem;
    letter-spacing: 1px;
  }

  .navbar-actions {
    gap: 0.3rem;
  }
}

@media (max-width: 480px) {
  .brand-name {
    display: none;
  }

  .nav-btn {
    font-size: 0.7rem;
    padding: 0.3rem 0.55rem;
  }
}
</style>