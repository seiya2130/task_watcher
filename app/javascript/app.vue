<template>
  <div id="app">
    <Header></Header>
    <Message></Message>
    <ErrorsMessage></ErrorsMessage>
    <router-view></router-view>
  </div>
</template>

<script>
import Header from './views/layouts/Header'
import Message from './views/layouts/Message'
import ErrorsMessage from './views/layouts/ErrorsMessage'

export default {
  data: function () {
    return {
      message: "Hello Vue!"
    }
  },
  components:{ 
    Header,
    Message,
    ErrorsMessage
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
