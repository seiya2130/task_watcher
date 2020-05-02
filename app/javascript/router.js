import Vue from 'vue'
import Router from 'vue-router'
import Top from './views/static_pages/Top'

Vue.use(Router)

export default new Router({
  mode: 'history',
  routes: [
    {
      path: '/',
      component: Top
    }
  ]
})