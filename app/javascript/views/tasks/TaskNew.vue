<template>
<section class="container">
    <div class="text-center mt-3">
        <span>タスクの情報を入力してください</span>
    </div>
    <div class="text-center py-3">
        <div class="my-3">
            <label class="d-block">タスク名</label>
            <input class="form w-50" v-model="task.name" type="text">
        </div>
        <div class="my-3">
            <label class="d-block">状態</label>
            <select v-model="task.status" class="form bg-white" value="未着手">
                <option v-for="(status,index) in statuses" :value="index" :key="index">
                    {{ status }}
                </option>
            </select>
        </div>
        <div class="my-3">
            <label class="d-block">期限</label>
            <datepicker v-model="task.deadLine" :format="DatePickerFormat" :language="ja" class="datepicker" ></datepicker>
        </div>
        <button class="btn standard" @click="createTask">作成</button>
    </div>
</section>

</template>
<script>
import http from '../../http'
import Datepicker from 'vuejs-datepicker'
import {ja} from 'vuejs-datepicker/dist/locale'

export default {
    data: function(){
        return {
            task:{
                name: '',
                status: '0',
                deadLine: new Date(),
                taskListId: this.$route.params.id
            },
            statuses: [
                '未着手',
                '進行中',
                '完了',
            ],
            DatePickerFormat: 'yyyy/MM/dd',
            ja:ja,
        }
    },
    components: {
        Datepicker
    },
    mounted () {
        http
        .get(`/api/v1/task_lists/${this.$route.params.id}/tasks/new`)
        .then(response => (console.log(response)))
        .catch(error => {
            console.error(error);
            if (error.response.data && error.response.data.errors) {
                this.$router.push({ name: 'Login'});
                this.$store.dispatch('setErrorsMessage',error.response.data.errors)
            }
        })
    },
    methods:{
        createTask: function(){
            http
            .post(`/api/v1/task_lists/${this.$route.params.id}/tasks`, 
                {
                task: {
                    name: this.task.name,
                    status: this.task.status,
                    dead_line: this.task.deadLine,
                    task_list_id : this.task.taskListId
                }
            })
            .then(response => {
                let e = response.data;
                this.$router.push({ name: 'TaskListShow', params: { id: this.$route.params.id }});
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