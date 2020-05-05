import Vue from 'vue';
import Vuex from 'vuex';
import createPersistedState from "vuex-persistedstate";

Vue.use(Vuex);

export default new Vuex.Store({
    state:{
        userId: '',
        userName: '',
        login: false,
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
        stateUserId: state => {
            return state.userId
        },
        stateUserName: state => {
            return state.userName
        },
        stateLogin: state => {
            return state.login
        },
    },
    mutations:{
        setMessage(state,message){
            state.message = message
        },
        setErrorsMessage(state,message){
            state.errorsMessage = message
        },
        setUserId(state,id){
            state.userId = id
        },
        setUserName(state,name){
            state.userName = name
        },
        login(state,flg){
            state.login = flg
        }
    },
    actions:{
        setMessage({ commit },message){
            commit('setMessage',message)
        },
        setErrorsMessage({ commit },message){
            commit('setErrorsMessage',message)
        },
        setUserId({ commit },id){
            commit('setUserId',id)
        },
        setUserName({ commit },name){
            commit('setUserName',name)
        },
        login({ commit },flg){
            commit('login',flg)
        },
    },
    plugins: [createPersistedState({storage: window.sessionStorage,key: 'TaskWatch'})]
})