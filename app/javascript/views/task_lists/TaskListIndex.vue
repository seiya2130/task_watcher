<template>
<section class="container">
    <div class="text-center my-3">  
        <router-link :to="{ name: 'TaskListNew'}" class="btn standard">タスクリスト作成</router-link>
    </div>
    <div v-if="taskLists.length > 0">
         <div v-for=" (taskList,index) in taskLists" :key="index" class="d-flex justify-content-between py-3 border-bottom">
            <div>
                <router-link :to="{ name: 'TaskListShow', params: { id: taskList.id }}">{{ taskList.name }}</router-link>
            </div>
            <div>
                <router-link :to="{ name: 'TaskListEdit', params: { id: taskList.id }}" class="btn standard">編集</router-link>
                <button class="btn delete" @click="deleteTaskList(taskList.id)">削除</button>
            </div>
        </div>
    </div>
    <div v-else>
        <p class="text-center">登録しているタスクリストがありません</p>
    </div>
</section>

</template>
<script>
import http from '../../http'

export default {
  data: function () {
    return {
      taskLists: []
    }
  },
  mounted () {
    http
    .get('/api/v1/task_lists')
    .then(response => (this.taskLists = response.data))
    .catch(error => {
        console.error(error);
        if (error.response.data && error.response.data.errors) {
            this.$router.push({ name: 'Login'});
            this.$store.dispatch('setErrorsMessage',error.response.data.errors)
        }
    })
  },
    methods:{
        deleteTaskList: function(taskListId){
            http
            .delete(`/api/v1/task_lists/${taskListId}`)
            .then(response => {
                let e = response.data;
                this.$router.push({ name: 'TaskListIndex'});
                this.taskLists = e.task_lists
                this.$store.dispatch('setMessage',e.message)
            })
            .catch(error => {
                console.error(error);
            });
        },
    }
}
</script>