<template>
    <section class="container">
        <div class="text-center mt-3">
            <span>ログイン情報を入力してください</span>
        </div>
        <div class="text-center py-3">
            <div class="my-3">
                <label class="d-block">メールアドレス</label> 
                <input class="form w-50" v-model="session.email" type="text">
            </div>
            <div class="my-3">
                <label class="d-block">パスワード</label>
                <input class="form w-50" v-model="session.password" type="password">
            </div>
            <button class="btn standard" @click="login()">ログイン</button>
            <div class="my-3">
                <button class="btn standard" @click="login('guest')">ゲストユーザーでログイン</button>
            </div>
        </div>
    </section>
</template>
<script>
import http from '../../http'

export default {
   data: function() {
       return {
           session: {
               email: '',
               password: ''
           },
       }
   },
   methods: {
        login: function(guest) {
            if(guest === 'guest'){
                this.session.email = 'guestuser@guestuser.com'
                this.session.password = 'vfr43edc'
            }
        http.post('/api/v1/sessions', 
        {
            session: {
                email: this.session.email,
                password: this.session.password
            }
        }).then( response => {
            let e = response.data;
            this.$router.push({ name: 'UserShow', params: { id: e.user.id } });
            this.$store.dispatch('setMessage',e.message)
            this.$store.dispatch('setUserId',e.user.id)
            this.$store.dispatch('setUserName',e.user.name)
            this.$store.dispatch('setEmail',e.user.email)
            this.$store.dispatch('login',true)
        }).catch(error => {
            console.error(error);
            if (error.response.data && error.response.data.errors) {
                this.$store.dispatch('setErrorsMessage', error.response.data.errors)
            }
        })
        }
    }
}
</script>