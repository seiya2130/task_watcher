<template>
    <section class="container">
        <h3 class="mt-3">
            進行中タスク : <span>{{ tasks.length }}</span>
        </h3>
        <div v-if="tasks.length > 0">
            <div class="text-center">
                <button @click="changeDisplay" class="btn standard">{{ buttonText }}</button>
            </div>
            <table class="mt-3">        
                <tr class="border-bottom">
                    <th>タスクリスト名</th>
                    <th>タスク名</th>
                    <th>期限</th>
                </tr>
                <tr v-for="(task,index) in tasks" :key="index" class="border-bottom">
                        <td class="my-3 py-3">
                            <router-link :to="{ name: 'TaskListShow', params: { id: taskLists[index].id }}">{{ taskLists[index].name }}</router-link>
                        </td>
                        <td class="my-3 py-3">
                            <router-link :to="{ name: 'TaskEdit', params: { id: task.id }}">{{ task.name }}</router-link>
                        </td>
                        <td class="my-3 py-3">
                            <span v-if="countDownFlg" :id="index">
                                {{ timers[index] }}
                                <!-- {{ getTimers(index) }} -->
                            </span>
                            <span v-else :id="index">
                                {{ convertDate(task.dead_line) }}
                            </span>
                        </td>
                    </tr>
            </table>
        </div>
        <div v-else>
            <p class="text-center mt-3">進行中のタスクがありません</p>
        </div>
    </section>
</template>
<script>
import http from '../../http'

export default {
  data: function () {
    return {
      tasks: [],
      taskLists:[],
      buttonText:'カウントダウン表示',
      countDownFlg: false,
      timers:[],
      timer:'',
    }
  },
  computed:{

  },
  methods:{
      convertDate: function(deadLine){
        let dl = new Date(deadLine);
        let year = dl.getFullYear();
        let month = dl.getMonth() + 1;
        let day = dl.getDate();
        return year + '/' + month + '/' + day
      },
      changeDisplay: function(){
        if(this.countDownFlg){
            this.buttonText = 'カウントダウン表示'
            this.countDownFlg = false
            clearTimeout(this.timer)
        }else{
            this.countDownFlg = true
            this.buttonText = '日付表示'
            this.recalc();
          }
      },
      recalc: function(){
        if(this.countDownFlg){
            let count = this.tasks.length;
            for(let i = 0; i < count; i++){
                let date = this.convertDate(this.tasks[i].dead_line).split("/")
                let year = date[0];
                let month = date[1];
                let day = date[2];
                let goal = new Date(year,month-1,day);
                goal.setHours(23);
                goal.setMinutes(59);
                goal.setSeconds(59);        
                let counter = this.countDown(goal);
                let time = counter[0] + '日' + counter[1] + '時間' + counter[2] + '分' + counter[3] + '秒';
                this.timers[i] = time
                this.$set(this.timers, i, time);
            }
        this.refresh();
        }
      },
      countDown: function(goal){
        let now = new Date();
        let rest = goal.getTime() - now.getTime();
        let sec = Math.floor(rest / 1000 % 60);
        let min = Math.floor(rest / 1000 / 60) % 60;
        let hours = Math.floor(rest / 1000 / 60 / 60) % 24;
        let days = Math.floor(rest / 1000 / 60 / 60 / 24);
        let count = [ days,hours, min, sec];
        return count
      },
      refresh: function(){
        this.timer = setTimeout(this.recalc, 1000);
      },
      getTimers: function(i){
          return this.timers[i]
      }
  },
  mounted () {
    http
    .get(`/api/v1/tasks/progress`)
    .then(response => (
        this.tasks = response.data.tasks,
        this.taskLists = response.data.task_lists
    ))
    .catch(error => {
        console.error(error);
        this.$router.push({ name: 'Login'});
        if (error.response.data && error.response.data.errors) {
            this.$store.dispatch('setErrorsMessage',error.response.data.errors)
        }
    })
  }
}
</script>