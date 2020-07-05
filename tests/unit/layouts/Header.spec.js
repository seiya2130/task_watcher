import { shallowMount, createLocalVue, RouterLinkStub, mount } from '@vue/test-utils'
import Vuex from 'vuex'
import Header from '../../../app/javascript/views/layouts/Header.vue'
import VueRouter from 'vue-router';
import flushPromises from 'flush-promises'
import { cloneDeep } from "lodash";
import storeConfig from './../../../app/javascript/store'
import router from '../../../app/javascript/router'

const localVue = createLocalVue()
localVue.use(Vuex)
localVue.use(VueRouter);
let store = undefined
let wrapper = undefined

jest.mock("../../../app/javascript/http", () => ({
    delete: jest.fn(() => Promise.resolve({ data: { message : 'ログアウトしました' } })),
}));

let testId = 1
let testName = 'test'

describe('Header', () => {
    describe('ログインしている場合', () => {

        beforeEach( async () => {
            
            store = new Vuex.Store(cloneDeep(storeConfig))
            store.state.userId = testId 
            store.state.userName= testName
            store.state.login = true

            wrapper = shallowMount(Header, { store, localVue,
                stubs: {
                    RouterLink: RouterLinkStub
                  },
                  router,
            })
            
            router.push({ name: 'UserShow', params: { id: testId }}).catch(err => {})
            await flushPromises()
            
        })

        describe('loggedIn', () =>{
            it('戻り値が返却されること', () => {
                expect(wrapper.vm.loggedIn).toBeTruthy()
            })
        })

        describe('userId', () =>{
            it('戻り値が返却されること', () => {
                expect(wrapper.vm.userId).toBe(testId)
            })
            it('戻り値がセットされること', () => {
                const links = wrapper.findAllComponents(RouterLinkStub)
                const userNameTag = links.at(1)
                expect(userNameTag.props().to.params.id).toBe(testId)
            })
        })

        describe('userName', () =>{
            it('戻り値が返却されること', () => {
                expect(wrapper.vm.userName).toBe(testName)
            })
            it('戻り値が描画されること', () => {
                const links = wrapper.findAllComponents(RouterLinkStub)
                const userNameTag = links.at(1)
                expect(userNameTag.text()).toBe(testName)
            })
        })

        describe('logout', () =>{
            beforeEach( async () => {
                try {
                    wrapper.find('button').trigger('click')                    
                    await flushPromises()
                } catch (e) {
                    console.error(e);
                }
            })  

            describe('setErrorsMessage', ()=> {
                it('戻り値がセットされること',  () => {
                    expect(store.getters.stateErrorsMessage).toEqual([])
               })
            })

            describe('router.push', ()=> {
                it('routeが変更されること',  () => {
                    expect(wrapper.vm.$route.name).toBe('Top')
               })
            })

            describe('setMessage', ()=> {
                it('戻り値がセットされること',  () => {
                    expect(store.getters.stateMessage).toBeDefined()
               })
            })

            describe('setUserId', ()=> {
                it('値が変更されること',  () => {
                    expect(store.getters.stateUserId).toBe('')
               })
            })

            describe('setUserId', ()=> {
                it('値が変更されること',  () => {
                    expect(store.getters.stateUserName).toBe('')
               })
            })

            describe('setUserId', ()=> {
                it('値が変更されること',  () => {
                    expect(store.getters.stateLogin).toBeFalsy()
               })
            })
        })

        describe('router-linkのtoプロパティに値がセットされている', () => {

            let links

            beforeEach(() => {
                links = wrapper.findAllComponents(RouterLinkStub)
            })

            it('/', () => {
                const link = links.at(0)
                expect(link.props().to).toBe('/')
            })

            it('UserShow', () => { 
                const link = links.at(1)
                expect(link.props().to.name).toBe('UserShow')
            })

            it('TaskProgress', () => {                
                const link = links.at(2)
                expect(link.props().to.name).toBe('TaskProgress')
            })   

            it('TaskListIndex', () => {
                const link = links.at(3)
                expect(link.props().to.name).toBe('TaskListIndex')
            })   
        })
    })

    describe('ログアウトしている場合', ()=>{
        
        beforeEach( async() => {
            
            store = new Vuex.Store(cloneDeep(storeConfig))
            
            wrapper = shallowMount(Header, { store, localVue,
                stubs: {
                    RouterLink: RouterLinkStub
                  },
                  router,
            })
 
            router.push({ name: 'UserShow', params: { id: testId }}).catch(err => {})
            await flushPromises()
        })

        describe('router-linkのtoプロパティに値がセットされている', () => {

            let links

            beforeEach(() => {
                links = wrapper.findAllComponents(RouterLinkStub)
            })

            it('/', () => {
                const link = links.at(0)
                expect(link.props().to).toBe('/')
            })

            it('/login', () => { 
                const link = links.at(1)
                expect(link.props().to).toBe('/login')
            })

            it('/signup', () => { 
                const link = links.at(2)
                expect(link.props().to).toBe('/signup')
            })
        })
    })
})

