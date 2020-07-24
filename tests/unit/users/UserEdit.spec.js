import { shallowMount, createLocalVue, RouterLinkStub } from '@vue/test-utils'
import Vuex from 'vuex'
import UserEdit from '../../../app/javascript/views/users/UserEdit'
import VueRouter from 'vue-router';
import flushPromises from 'flush-promises'
import { cloneDeep } from "lodash";
import storeConfig from './../../../app/javascript/store'
import router from '../../../app/javascript/router'
import MockAdapter from "axios-mock-adapter";
import http from '../../../app/javascript/http'

const localVue = createLocalVue()
localVue.use(Vuex)
localVue.use(VueRouter);
let store = undefined
let wrapper = undefined

const mockAxios = new MockAdapter(http);

const testId = 1
const testName = 'test'
const testName2 = 'test2'
let testEmail = 'test@test.com'
let guestEmail = 'guestuser@guestuser.com'
const testPassword = 'password'
const testMsg = 'メッセージ'

describe('UserEdit', ()=>{

    describe('updateUser', ()=>{
        describe('正常',()=>{
            beforeEach( async()=>{

                let getResponse = {  
                    id: testId,
                    name: testName,
                    email: testEmail
                }

                let postResponse = {  
                    user: {
                        id: testId,
                        name: testName2,
                        email: testEmail
                    },
                    message: testMsg
                }

                mockAxios.onGet(`/api/v1/users/${testId}.json`).reply(200, getResponse)
                mockAxios.onPatch(`/api/v1/users/${testId}`).reply(200, postResponse)

                store = new Vuex.Store(cloneDeep(storeConfig))
                store.state.userId = testId 
                store.state.userName= testName
                store.state.email= testEmail
                store.state.login = true
        
                router.push({ name: 'UserEdit', params: { id: testId }}).catch(() => {})
                await flushPromises()

                wrapper = shallowMount(UserEdit, { store, localVue,
                    stubs: {
                        RouterLink: RouterLinkStub
                      },
                    router,
                })

                const inputs = wrapper.findAll('input')
                    inputs.at(0).setValue(testName2)
                    inputs.at(1).setValue(testEmail)
                    inputs.at(2).setValue(testPassword)

                    try {
                        wrapper.find('button').trigger('click')                    
                        await flushPromises()
                    } catch (e) {
                        console.error(e);
                    }
            })


            describe('router.push', ()=> {
                it('routeが変更されること',  () => {
                    expect(wrapper.vm.$route.name).toBe('UserShow')
                    expect(wrapper.vm.$route.params.id).toBe(testId)
                })
            })

            describe('setMessage', ()=> {
                it('戻り値がセットされること',  () => {
                    expect(store.getters.stateMessage).toBeDefined()
                })
            })

        })

        describe('エラー',()=>{
            beforeEach( async()=>{

                let getResponse = {  
                    id: testId,
                    name: testName,
                    email: testEmail
                }

                let postResponse = {  
                    errors:['エラー']
                }

                mockAxios.onGet(`/api/v1/users/${testId}.json`).reply(200, getResponse)
                mockAxios.onPatch(`/api/v1/users/${testId}`).reply(500, postResponse)

                store = new Vuex.Store(cloneDeep(storeConfig))
                store.state.userId = testId 
                store.state.userName= testName
                store.state.email= testEmail
                store.state.login = true
        
                router.push({ name: 'UserEdit', params: { id: testId }}).catch(() => {})
                await flushPromises()

                wrapper = shallowMount(UserEdit, { store, localVue,
                    stubs: {
                        RouterLink: RouterLinkStub
                      },
                    router,
                })
            })

            describe('setErrorsMessage', ()=> {
                it('戻り値がセットされること',  () => {
                    expect(store.getters.stateErrorsMessage).toBeDefined();
               })
            })

        })
    })

    describe('mounted', ()=>{
        describe('正常(通常ユーザー)',()=>{
            beforeEach( async()=>{

                let getResponse = {  
                    id: testId,
                    name: testName,
                    email: testEmail
                }

                mockAxios.onGet(`/api/v1/users/${testId}.json`).reply(200, getResponse)

                store = new Vuex.Store(cloneDeep(storeConfig))
                store.state.userId = testId 
                store.state.userName= testName
                store.state.email= testEmail
                store.state.login = true
        
                router.push({ name: 'UserEdit', params: { id: testId }}).catch(() => {})
                await flushPromises()

                wrapper = shallowMount(UserEdit, { store, localVue,
                    stubs: {
                        RouterLink: RouterLinkStub
                      },
                    router,
                })
            })

            describe('vm.user', ()=>{
                it('値がセットされること', () => {
                    expect(wrapper.vm.user.id).toBe(testId)
                    expect(wrapper.vm.user.name).toBe(testName)
                    expect(wrapper.vm.user.email).toBe(testEmail)
                })
            })


        })
        describe('正常(ゲストユーザー)',()=>{
            beforeEach( async()=>{

                let getResponse = {  
                    id: testId,
                    name: testName,
                    email: guestEmail
                }

                mockAxios.onGet(`/api/v1/users/${testId}.json`).reply(200, getResponse)

                store = new Vuex.Store(cloneDeep(storeConfig))
                store.state.userId = testId 
                store.state.userName= testName
                store.state.email= guestEmail
                store.state.login = true
        
                router.push({ name: 'UserEdit', params: { id: testId }}).catch(() => {})
                await flushPromises()

                wrapper = shallowMount(UserEdit, { store, localVue,
                    stubs: {
                        RouterLink: RouterLinkStub
                      },
                    router,
                })
            })

            describe('router.push', ()=> {
                it('routeが変更されること',  () => {
                    expect(wrapper.vm.$route.name).toBe('Top')
                })
            })

            describe('setErrorsMessage', ()=> {
                it('戻り値がセットされること',  () => {
                    expect(store.getters.stateErrorsMessage).toBeDefined();
               })
            })

        })
        describe('エラー',()=>{
            beforeEach( async()=>{

                let getResponse = {  
                    errors:['エラー']
                }

                mockAxios.onGet(`/api/v1/users/2.json`).reply(500, getResponse)

                store = new Vuex.Store(cloneDeep(storeConfig))
                store.state.userId = testId 
                store.state.userName= testName
                store.state.email= testEmail
                store.state.login = true
        
                router.push({ name: 'UserEdit', params: { id: testId }}).catch(() => {})
                await flushPromises()

                wrapper = shallowMount(UserEdit, { store, localVue,
                    stubs: {
                        RouterLink: RouterLinkStub
                      },
                    router,
                })
            })

            describe('router.push', ()=> {
                it('routeが変更されること',  () => {
                    expect(wrapper.vm.$route.name).toBe('Top')
                })
            })

            describe('setErrorsMessage', ()=> {
                it('戻り値がセットされること',  () => {
                    expect(store.getters.stateErrorsMessage).toBeDefined();
               })
            })
        })
    })
})