import Vue from 'vue';
import Vuex from 'vuex';

Vue.use(Vuex);

export default new Vuex.Store({
    state:{
        isLogin: false,
        message:'',
        errorsMessage:[],
    },
    getters:{
        stateMessage: state => {
            return state.message
          },
        stateErrorsMessage: state => {
            return state.errorsMessage
          },
    },
    mutations:{
        setMessage(state,message){
            state.message = message
        },
        setErrorsMessage(state,message){
            state.errorsMessage = message
        }
    },
    actions:{
        setMessage({ commit },message){
            commit('setMessage',message)
        },
        setErrorsMessage({ commit },message){
            commit('setErrorsMessage',message)
        }
    }
})