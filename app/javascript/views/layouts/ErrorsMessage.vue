<template>
    <ul v-if="existErrorsMessage" class="container">
      <li 
        class="msg error my-3"
        v-for="(e,index) in errorsMessage" 
        :key="index">
        {{ e }}
      </li>
    </ul>
</template>
<script>
export default {
    data: function(){
      return {
        errorsMessage:[]
      }
    },
    computed: {
      existErrorsMessage: function(){
        let message = this.$store.getters.stateErrorsMessage
        if(message.length > 0){
          this.errorsMessage = message
          return true
        }else{
          return false
        }
      }
    }
}
</script>