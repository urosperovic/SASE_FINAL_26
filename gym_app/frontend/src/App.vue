<script setup lang="ts">
import Navbar from './components/Navbar.vue';
import { useRoute } from 'vue-router';

const year = new Date().getFullYear();
const route = useRoute();
</script>

<template>
  <div class="app-shell">
    <Navbar />
    <RouterView />
    <footer class="app-footer">
      <span class="footer-brand">⚡ IRONFORGE GYM</span>
      <span class="footer-copy">&copy; {{ year }} Singidunum University – SDE</span>
    </footer>
  </div>
</template>

<style>
@import url('https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@700;900&family=DM+Sans:wght@400;500&display=swap');

*, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

body {
  background: #0f0f0f;
  color: #fff;
  font-family: 'DM Sans', sans-serif;
}

.app-shell {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.app-footer {
  margin-top: auto;
  border-top: 1px solid #1e1e1e;
  padding: 1.25rem 3rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: #0f0f0f;
}

.footer-brand {
  font-family: 'Barlow Condensed', sans-serif;
  font-weight: 900;
  font-size: 1rem;
  letter-spacing: 3px;
  text-transform: uppercase;
  color: #e8ff00;
}

.footer-copy {
  font-size: 0.8rem;
  color: #444;
  letter-spacing: 1px;
}

@media (max-width: 600px) {
  .app-footer {
    flex-direction: column;
    gap: 0.5rem;
    padding: 1.25rem;
    text-align: center;
  }
}
</style>