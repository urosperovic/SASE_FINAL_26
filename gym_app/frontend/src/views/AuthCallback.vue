<template>
  <div class="container mt-5 text-center">
    <div class="spinner-border text-primary" role="status"></div>
    <p class="mt-3">Signing you in...</p>
  </div>
</template>

<script setup lang="ts">
import { onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { SessionManager } from '@/utils/session.manager'

const router = useRouter()

onMounted(() => {
  const params = new URLSearchParams(window.location.search)
  const accessToken = params.get('accessToken')
  const refreshToken = params.get('refreshToken')

  if (accessToken && refreshToken) {
    SessionManager.saveAuth({ accessToken, refreshToken })
    router.push('/')
  } else {
    router.push('/login')
  }
})
</script>