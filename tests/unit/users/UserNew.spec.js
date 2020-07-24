import { shallowMount, createLocalVue } from '@vue/test-utils'
import Vuex from 'vuex'
import UserNew from '../../../app/javascript/views/users/UserNew'
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

describe('UserNew', () => {

    beforeEach( async () => {
        
        store = new Vuex.Store(cloneDeep(storeConfig))

        wrapper = shallowMount(UserNew, { store, localVue,router,})
        
        router.push('/signup').catch(err => {})
        await flushPromises()
        
    })

    describe('createUser',()=>{

        describe('正常', () =>{

            const testName = 'test'
            const testEmail = 'test@test.com'
            const testPassword = 'password'
            const testId = 1
            
            const response = {  
                message : 'ユーザーを登録しました',
                user: {
                    id: testId,
                    name: testName,
                    email: testEmail
                }
            }

            beforeEach( async() => {

                mockAxios.onPost('/api/v1/users').reply(200, response)
                const inputs = wrapper.findAll('input')
    
                inputs.at(0).setValue(testName)
                inputs.at(1).setValue(testEmail)
                inputs.at(2).setValue(testPassword)

                try {
                    wrapper.find('button').trigger('click')                    
                    await flushPromises()
                } catch (e) {
                    console.error(e);
                }
            });

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

            describe('setUserId', ()=> {
                it('値が変更されること',  () => {
                    expect(store.getters.stateUserId).toBe(testId)
               })
            })

            describe('setUserName', ()=> {
                it('値が変更されること',  () => {
                    expect(store.getters.stateUserName).toBe(testName)
               })
            })

            describe('setEmail', ()=> {
                it('戻り値がセットされること',  () => {
                    expect(store.getters.stateEmail).toBe(testEmail)
               })
            })

            describe('login', ()=> {
                it('値が変更されること',  () => {
                    expect(store.getters.stateLogin).toBeTruthly
                })
            })
        })

        describe('エラー', () =>{

            const response = {  
                errors : ['パスワードを入力してください']
            }
            
            beforeEach( async() => {
  
                mockAxios.onPost('/api/v1/users').reply(500, response)

                try {
                    wrapper.find('button').trigger('click')                    
                    await flushPromises()
                } catch (e) {
                    console.error(e);
                }
            });

            describe('setErrorsMessage', ()=> {
                it('戻り値がセットされること',  () => {
                    expect(store.getters.stateErrorsMessage).toBeDefined();
               })
            })
        })
    })
})

