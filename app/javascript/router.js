import Vue from 'vue'
import Router from 'vue-router'
import Top from './views/static_pages/Top'
import UserNew from './views/users/UserNew'
import UserShow from './views/users/UserShow'
import UserEdit from './views/users/UserEdit'
import NotFoundPage from './views/layouts/NotFoundPage'
import SessionNew from './views/sessions/SessionNew'
import TaskListNew from './views/task_lists/TaskListNew'
import TaskListIndex from './views/task_lists/TaskListIndex'
import TaskListEdit from './views/task_lists/TaskListEdit'
import TaskListShow from './views/task_lists/TaskListShow'
import TaskNew from './views/tasks/TaskNew'
import TaskEdit from './views/tasks/TaskEdit'
import TaskProgress from './views/tasks/TaskProgress'
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
      name: 'Login',
      component: SessionNew
    },
    { 
      path: '/task_lists/new',
      name: 'TaskListNew',
      component: TaskListNew
    },
    { 
      path: '/task_lists',
      name: 'TaskListIndex',
      component: TaskListIndex
    },
    { 
      path: '/task_lists/:id/edit',
      name: 'TaskListEdit',
      component: TaskListEdit
    },
    { 
      path: '/task_lists/:id',
      name: 'TaskListShow',
      component: TaskListShow
    },
    { 
      path: '/task_lists/:id/tasks/new',
      name: 'TaskNew',
      component: TaskNew
    },
    { 
      path: '/tasks/:id/edit',
      name: 'TaskEdit',
      component: TaskEdit
    },
    { 
      path: '/tasks/progress',
      name: 'TaskProgress',
      component: TaskProgress
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