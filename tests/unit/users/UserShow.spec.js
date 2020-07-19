import { shallowMount, createLocalVue, RouterLinkStub } from '@vue/test-utils'
import Vuex from 'vuex'
import UserShow from '../../../app/javascript/views/users/UserShow'
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
let testEmail = 'test@test.com'

describe('UserShow', () => {

    describe('notGuestUser', ()=>{

        describe('通常ユーザーの場合', ()=>{

            beforeEach( async()=>{

                let response = {  
                    id: testId,
                    name: testName,
                    email: testEmail
                }

                mockAxios.onGet(`/api/v1/users/${testId}.json`).reply(200, response)
                store = new Vuex.Store(cloneDeep(storeConfig))
                store.state.userId = testId 
                store.state.userName= testName
                store.state.email= testEmail
                store.state.login = true

                router.push({ name: 'UserShow', params: { id: testId }}).catch(() => {})
                await flushPromises()
        
                wrapper = shallowMount(UserShow, { store, localVue,
                    stubs: {
                        RouterLink: RouterLinkStub
                      },
                    router,
                })
            })

            it('戻り値が返却される',()=>{
                expect(wrapper.vm.notGuestUser).toBeTruthy()
            })

            it('値がセットされること', () => {
                expect(wrapper.vm.user.id).toBe(testId)
                expect(wrapper.vm.user.name).toBe(testName)
                expect(wrapper.vm.user.email).toBe(testEmail)
            })

            it('画面に描画される', ()=>{
                expect(wrapper.find('[name="name"]').text()).toBe(testName)
                expect(wrapper.find('[name="email"]').text()).toBe(testEmail)
            })

            it('router-linkが表示される', ()=>{
                const links = wrapper.findAllComponents(RouterLinkStub)
                const link = links.at(0)
                expect(link.props().to.name).toBe('UserEdit')
            })

        })

        describe('ゲストユーザーの場合', ()=>{

            beforeEach( async()=>{

                let response = {  
                    id: testId,
                    name: testName,
                    email: 'guestuser@guestuser.com'
                }

                mockAxios.onGet(`/api/v1/users/${testId}.json`).reply(200, response)
                store = new Vuex.Store(cloneDeep(storeConfig))
                store.state.userId = testId 
                store.state.userName= testName
                store.state.email= 'guestuser@guestuser.com'
                store.state.login = true

                router.push({ name: 'UserShow', params: { id: testId }}).catch(() => {})
                await flushPromises()
        
                wrapper = shallowMount(UserShow, { store, localVue,
                    stubs: {
                        RouterLink: RouterLinkStub
                      },
                    router,
                })
            })

            it('戻り値が返却される',()=>{
                expect(wrapper.vm.notGuestUser).toBeFalsy()
            })

            it('router-linkが表示されない', ()=>{
                const links = wrapper.findAllComponents(RouterLinkStub)
                expect(links.length).toBe(0)
            })

        })

    })

    describe('/api/v1/users/:id', ()=>{
        
        describe('ユーザー情報が取得できない場合', ()=>{

            beforeEach( async()=>{

                let response = {  
                    errors:['エラー']
                }

                mockAxios.onGet(`/api/v1/users/${testId}.json`).reply(500, response)
                store = new Vuex.Store(cloneDeep(storeConfig))
                store.state.userId = testId 
                store.state.userName= testName
                store.state.email= testEmail
                store.state.login = true

                router.push({ name: 'UserShow', params: { id: testId }}).catch(() => {})
                await flushPromises()
        
                wrapper = shallowMount(UserShow, { store, localVue,
                    stubs: {
                        RouterLink: RouterLinkStub
                      },
                    router,
                })

                router.push({ name: 'UserShow', params: { id: 2 }}).catch(() => {})
                await flushPromises()
            })

            describe('router.push', ()=> {
                it('routeが変更されること',  async() => {
                    expect(wrapper.vm.$route.name).toBe('Top')
               })
            })

            describe('setErrorsMessage', ()=> {
                it('戻り値がセットされること',  async() => {
                    expect(store.getters.stateErrorsMessage).toBeDefined();
               })
            })
            
        })
    })

})

