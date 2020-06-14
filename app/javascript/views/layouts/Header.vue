<template>
<header class="py-3 bg-header">
    <div class="container d-flex justify-content-between">
        <div>
            <div>
                <router-link to="/" class="header-text text-white">TaskWatch</router-link>
            </div>
        </div>
        <div v-if="loggedIn" class="d-flex">
            <div class="mx-3">
                <router-link :to="{ name: 'UserShow', params: { id: userId }}" class="text-white">{{ userName }}</router-link>
            </div>
            <div class="mx-3">
                <router-link :to="{ name: 'TaskProgress'}" class="text-white">進行中タスク一覧</router-link>
            </div>
            <div class="mx-3">
                <router-link :to="{ name: 'TaskListIndex'}" class="text-white">タスクリスト一覧</router-link>
            </div>
            <div class="mx-3">
                <a><button class="text-white" @click="logout">ログアウト</button></a>
            </div>
        </div>   
        <div v-else class="d-flex">
            <div class="mx-3">
                <router-link to="/login" class="text-white">ログイン</router-link>
            </div>
            <div class="mx-3">
                <router-link to="/signup" class="text-white">新規登録</router-link>
            </div>
        </div>
    </div>
</header>
</template>

<script>
import http from '../../http'

export default {
    computed: {
        loggedIn: function(){
            return this.$store.getters.stateLogin
        },
        userId: function(){
            return this.$store.getters.stateUserId
        },
        userName: function(){
            return this.$store.getters.stateUserName
        },
    },
    methods:{
        logout: function(){
            http
            .delete(`/api/v1/sessions/${this.$store.getters.stateUserId}`)
            .then(response => {
            let e = response.data;
            this.$store.dispatch('setErrorsMessage',[])
            this.$router.push({ name: 'Top' });
            this.$store.dispatch('setMessage',e.message)
            this.$store.dispatch('setUserId','')
            this.$store.dispatch('setUserName','')
            this.$store.dispatch('login',false)
            })
            .catch(error => {
            console.error(error);
            });
        },
    }
}
</script>
<style scoped>
</style>