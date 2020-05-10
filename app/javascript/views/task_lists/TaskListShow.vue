<template>
    <section class="container">
        <h3 class="mt-3">
            <p>{{ taskList.name }}</p>
        </h3>
        <div class="text-center mb-3">
             <router-link :to="{ name: 'TaskNew', params: { id: taskList.id }}" class="btn standard">タスク作成</router-link>
        </div>
        <table v-if="tasks.length > 0" class="mt-3">        
            <tr class="border-bottom">
                <th>タスク名</th>
                <th>状態</th>
                <th>期限</th>
                <th></th>
            </tr>
            <tr v-for="(task,index) in tasks" :key="index" class="border-bottom">
                <td class="my-3 py-3">
                     <router-link :to="{ name: 'TaskEdit', params: { id: task.id }}">{{ task.name }}</router-link>
                </td>
                <td class="my-3 py-3">
                    {{ convertStatus(task.status) }}
                </td>
                <td class="my-3 py-3">
                    {{ convertDate(task.dead_line) }}
                </td>
                <td class="my-3 py-3">
                    <button class="btn delete" @click="deleteTask(task.id)">削除</button>
                </td>
            </tr>
        </table>
        <div v-else>
            <p class="text-center">登録しているタスクがありません</p>
        </div>
</section>

</template>
<script>
import http from '../../http'

export default {
  data: function () {
    return {
      taskList: {},
      tasks: []
    }
  },
  methods:{
      convertStatus: function(statusCode){
          if( statusCode === '0' ){
              return '未着手'
          }else if( statusCode === '1' ){
              return '進行中'
          }else if( statusCode === '2' ){
              return '完了'
          }
      },
      convertDate: function(deadLine){
        let dl = new Date(deadLine);
        let year = dl.getFullYear();
        let month = dl.getMonth() + 1;
        let day = dl.getDate();
        return year + '/' + month + '/' + day
      },
    deleteTask: function(taskId){
        http
        .delete(`/api/v1/tasks/${taskId}`)
        .then(response => {
            let e = response.data;
            this.tasks = e.tasks
            this.$store.dispatch('setMessage',e.message)
        })
        .catch(error => {
            console.error(error);
        });
    }
  },
  mounted () {
    http
    .get(`/api/v1/task_lists/${this.$route.params.id}.json`)
    .then(response => (
        this.taskList = response.data.taskList,
        this.tasks = response.data.tasks
    ))
    .catch(error => {
        console.error(error);
        this.$router.push({ name: 'Top' });
        if (error.response.data && error.response.data.errors) {
        this.$store.dispatch('setErrorsMessage',error.response.data.errors)
        }
    })
  }
}
</script>