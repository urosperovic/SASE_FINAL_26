import { createRouter, createWebHistory } from 'vue-router'
import { SessionManager } from '@/utils/session.manager'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'Home',
      component: () => import('../views/HomeView.vue')
    },
    {
      path: '/login',
      name: 'Login',
      component: () => import('../views/LoginView.vue')
    },
    {
      path: '/signup',
      name: 'signup',
      component: () => import('../views/SignUpView.vue')
    },
    {
      path: '/selected',
      name: 'selected',
      component: () => import('../views/Selected.vue')
    },
    {
      path: '/admin',
      name: 'admin',
      component: () => import('../views/AdminView.vue'),
      beforeEnter: (to, from, next) => {
        const token = SessionManager.getAccessToken(); // ← use SessionManager
        if (!token) return next('/login');
        try {
          const payload = JSON.parse(atob(token.split('.')[1]));
          if (payload.role === 'admin') next();
          else next('/');
        } catch {
          next('/login');
        }
      }
    }
  ]
})

export default router