<template>
    <div class="container">
        <div v-if="existMessage" class="msg standard my-3">
            <span>{{ message }}</span>
        </div>
</div>  
</template>
<script>
export default {
    data: function(){
        return {
            message: ''
        }
    },
    computed:{
        existMessage: function(){
            let message = this.$store.getters.stateMessage
            if(message.length > 0){
                this.message = message
                return true
            }else{
                return false
            }
        }
    }
}
</script>