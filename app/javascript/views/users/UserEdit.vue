<template>
    <section class="container">
        <div class="text-center mt-3">
            <span>ユーザー情報を編集してください</span>
        </div>
        <div class="text-center py-3">
            <div class="my-3">
                <label class="d-block">ユーザー名</label>
                <input class="form w-50" v-model="user.name" type="text">
            </div>
            <div class="my-3">
                <label class="d-block">メールアドレス</label> 
                <input class="form w-50" v-model="user.email" type="text">
            </div>
            <div class="my-3">
                <label class="d-block">パスワード</label>
                <input class="form w-50" v-model="user.password" type="password">
            </div>
            <button class="btn standard" @click="updateUser">更新</button>
        </div>
    </section>
</template>
<script>
import http from '../../http'
export default {
  data: function () {
    return {
        user: {
            name: '',
            email: '',
            password: ''
        },
    }
  },
  mounted () {
    http
      .get(`/api/v1/users/${this.$route.params.id}.json`)
      .then(response => (this.user = response.data))
      .catch(error => {
        console.error(error);
        if (error.response.data && error.response.data.errors) {
            this.$router.push({ name: 'Top'});
            this.$store.dispatch('setErrorsMessage',error.response.data.errors) 
        }
    })
  },
    methods: {
        updateUser: function() {
            http
            .patch(`/api/v1/users/${this.user.id}`, 
            {
                user: {
                    name: this.user.name,
                    email: this.user.email,
                    password: this.user.password
                }
            })
            .then(response => {
                let e = response.data;
                this.$router.push({ name: 'UserShow', params: { id: e.user.id } });
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