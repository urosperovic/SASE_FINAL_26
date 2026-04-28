<script setup lang="ts">
import { RouterLink } from 'vue-router';

export interface NavbarRouteProps {
  name: string;
  to: string;
}

const { name, to } = defineProps<NavbarRouteProps>();
</script>

<template>
  <li class="nav-route-item">
    <RouterLink :to="to" class="nav-route-link">
      <span class="link-label">{{ name }}</span>
      <span class="link-bar"></span>
    </RouterLink>
  </li>
</template>

<style scoped>
@import url('https://fonts.googleapis.com/css2?family=Barlow+Condensed:wght@700;900&family=DM+Sans:wght@400;500&display=swap');

.nav-route-item {
  list-style: none;
}

.nav-route-link {
  font-family: 'Barlow Condensed', sans-serif;
  font-weight: 700;
  font-size: 0.85rem;
  letter-spacing: 2px;
  text-transform: uppercase;
  color: #666;
  text-decoration: none;
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0px;
  padding: 0.25rem 0;
  position: relative;
  transition: color 0.18s ease;
}

.link-bar {
  display: block;
  height: 2px;
  width: 0%;
  background: #e8ff00;
  border-radius: 2px;
  transition: width 0.2s ease;
  margin-top: 3px;
}

.nav-route-link:hover,
.nav-route-link.router-link-active {
  color: #fff;
}

.nav-route-link:hover .link-bar,
.nav-route-link.router-link-active .link-bar {
  width: 100%;
}

.nav-route-link.router-link-active {
  color: #e8ff00;
}

.nav-route-link.router-link-active .link-bar {
  background: #e8ff00;
}
</style>