<script setup lang="ts">
import { useRouter } from 'vue-router';
import { SessionManager } from '../utils/session.manager';
import { useLogout } from '../utils/logout.hook';

const router = useRouter();

function goToLogin() {
  router.push('/login');
}

const logout = useLogout();

const isAuthenticated = () => SessionManager.hasAuth();
</script>

<template>
  <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
    <div class="container">
      <router-link to="/" class="navbar-brand">
        <img src="https://marketplace.canva.com/EAFR5zOv2_c/2/0/1600w/canva-green-modern-fitness-app-logo-sE0Hizm2VsU.jpg" alt="Logo" width="80" height="65" class="d-inline-block align-text-top me-0">
      </router-link>

      <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span class="navbar-toggler-icon"></span>
      </button>

      <div class="collapse navbar-collapse" id="navbarNav">
        <ul class="navbar-nav ms-auto">
          <li class="nav-item" v-if="!isAuthenticated()">
            <button class="btn btn-outline-warning me-2" @click="goToLogin">Login</button>
          </li>
          <li class="nav-item" v-else>
            <button class="btn btn-outline-danger me-2" @click="logout">Logout</button>
          </li>
          <li class="nav-item" v-if="isAuthenticated()">
            <button class="btn btn-outline-success" @click="$router.push('/selected')">My Trainers</button>
          </li>
        </ul>
        
      </div>
    </div>
  </nav>
</template>

