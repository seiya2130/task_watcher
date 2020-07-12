import { shallowMount, createLocalVue } from '@vue/test-utils'
import Vuex from 'vuex'
import SessionNew from '../../../app/javascript/views/sessions/SessionNew'
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

describe('SessionNew', () => {

    beforeEach( async () => {
        
        store = new Vuex.Store(cloneDeep(storeConfig))

        wrapper = shallowMount(SessionNew, { store, localVue,router,})
        
        router.push({ name: 'Login' }).catch(err => {})
        await flushPromises()
        
    })

    describe('login', () => {

        describe('正常',  () => {

            const testEmail = 'test@test.com'
            const testPassword = 'password'
            const testId = 1
            const testName = 'test'

            const response = {  
                message : 'ログインしました',
                user: {
                    id: testId,
                    name: testName,
                    email: testEmail
                }
            }
            mockAxios.onPost('/api/v1/sessions').reply(200, response)

            describe('通常ユーザー', () => {

                beforeEach( async () => {
                    const inputs = wrapper.findAll('input')

                    inputs.at(0).setValue(testEmail)
                    inputs.at(1).setValue(testPassword)

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

                describe('setUserId', ()=> {
                    it('戻り値がセットされること',  () => {
                        expect(store.getters.stateUserId).toBe(testId)
                   })
                })

                describe('setUserName', ()=> {
                    it('戻り値がセットされること',  () => {
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

            describe('ゲストユーザー', () => {
    
                beforeEach( async () => {
                    // 値をセット
                    // ボタン桜花
                    // flushpromise

                })

                // it('戻り値が返却されること', () => {
                //     expect(wrapper.vm.loggedIn).toBeTruthy()
                // })

                // routerpush
                // メッセージ
                // ID
                // 名前
                // email
                // login
            })
        })

        describe('エラー',  () => {
            beforeEach( async () => {
                const response = {  
                    errors : ['メールアドレスまたはパスワードが誤っています']
                }
                mockAxios.onPost('/api/v1/sessions').reply(500, response)
    
                const inputs = wrapper.findAll('input')

                try {
                    wrapper.find('button').trigger('click')  
                    await flushPromises()
                } catch (e) {
                    console.error(e);
                }

            })

            describe('setErrorsMessage', ()=> {
                it('戻り値がセットされること',  () => {
                    expect(store.getters.stateErrorsMessage).toBeDefined();
               })
            })
        })
    })
})

