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
      <div class="text-center mt-3">
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
  mounted () {
    http
      .get(`/api/v1/users/${this.$route.params.id}.json`)
      .then(response => (this.user = response.data))
  }
}
</script>