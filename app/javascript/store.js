import Vue from 'vue';
import Vuex from 'vuex';
import createPersistedState from "vuex-persistedstate";

Vue.use(Vuex);

export default new Vuex.Store({
    state:{
        userId: '',
        userName: '',
        email: '',
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
        stateEmail: state => {
            return state.email
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
        setEmail(state,email){
            state.email = email
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
        setEmail({ commit },email){
            commit('setEmail',email)
        },
        login({ commit },flg){
            commit('login',flg)
        },
    },
    plugins: [createPersistedState({storage: window.sessionStorage,key: 'TaskWatch'})]
})