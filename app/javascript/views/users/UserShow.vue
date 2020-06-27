<template>
  <section class="container">
      <div class="text-center mt-3">
          <p>ユーザー名</p>
          <p>{{ user.name }}</p>
      </div>
      <div class="text-center mt-3">
          <p>メールアドレス</p>
          <p>{{ user.email }}</p>
      </div>
      <div v-if="notGuestUser" class="text-center mt-3">
        <router-link class="btn standard" :to="{ name: 'UserEdit', params: { id: user.id }}">編集</router-link>
      </div>
  </section>
</template>
<script>
import http from '../../http'

export default {
  data: function () {
    return {
      user: {}
    }
  },
  computed: {
    notGuestUser: function(){
      let email = this.$store.getters.stateEmail
      if(email == 'guestuser@guestuser.com'){
        return false
      }else{
        return true
      }
    }
  },
  mounted () {
    http
      .get(`/api/v1/users/${this.$route.params.id}.json`)
      .then(response => (this.user = response.data))
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