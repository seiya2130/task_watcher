import Vue from 'vue'
import Router from 'vue-router'
import Top from './views/static_pages/Top'
import UserNew from './views/users/UserNew'
import UserShow from './views/users/UserShow'
import UserEdit from './views/users/UserEdit'
import NotFoundPage from './views/layouts/NotFoundPage'
import SessionNew from './views/sessions/SessionNew'
import store from './store'

Vue.use(Router)

const router =  new Router({
  mode: 'history',
  routes: [
    {
        path: '/',
        name: 'Top',
        component: Top
    },
    {
        path: '/signup',
        component: UserNew
    },
    { 
      path: '/users/:id',
      name: 'UserShow',
      component: UserShow 
    },
    { 
      path: '/users/:id/edit',
      name: 'UserEdit',
      component: UserEdit
    },
    { 
      path: '/login',
      component: SessionNew
    },
    {
      path: '*',
      component: NotFoundPage
    },
  ]
})

router.beforeEach((to, from, next) => {
  let message = store.getters.stateMessage
  let errorsMessage = store.getters.stateErrorsMessage
  if( message !='' || errorsMessage.length > 0){
    store.dispatch('setMessage','')
    store.dispatch('setErrorsMessage',[])
  }
  next()
});

export default router