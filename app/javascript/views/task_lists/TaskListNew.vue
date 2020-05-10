<template>
    <section class="container">
    <div class="text-center my-3 py-3">
        <p>タスクリスト名を入力してください</p>
            <div class="my-3">
                <input class="form w-50" v-model="taskList.name" type="text">
            </div>
        <button class="btn standard mt-3" @click="createTaskList">作成</button>
    </div>
</section>
</template>
<script>
import http from '../../http'

export default {
   data: function() {
       return {
           taskList: {
               name: '',
           },
       }
   },
    mounted () {
        http
        .get('/api/v1/task_lists/new')
        .then(response => (console.log(response)))
        .catch(error => {
            console.error(error);
            if (error.response.data && error.response.data.errors) {
                this.$router.push({ name: 'Login'});
                this.$store.dispatch('setErrorsMessage',error.response.data.errors)
            }
        })
    },
    methods: {
       createTaskList: function() {
        http
        .post('/api/v1/task_lists', 
         {
            task_list: {
                name: this.taskList.name,
            }
        })
        .then(response => {
          let e = response.data;
          this.$router.push({ name: 'TaskListIndex'});
          this.$store.dispatch('setMessage',e.message)
        })
        .catch(error => {
          console.error(error);
          if (error.response.data && error.response.data.errors) {
            this.$store.dispatch('setErrorsMessage',error.response.data.errors)
          }
        });
       }
   }
}
</script>