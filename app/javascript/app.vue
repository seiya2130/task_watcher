<template>
  <div id="app">
    <Header></Header>
    <router-view></router-view>
  </div>
</template>

<script>
import Header from './views/layouts/Header'

export default {
  data: function () {
    return {
      message: "Hello Vue!"
    }
  },
  components:{ 
    Header
  }
}
</script>

<style scoped>
p {
  font-size: 2em;
  text-align: center;
}
</style>
