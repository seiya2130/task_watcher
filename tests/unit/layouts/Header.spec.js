import { shallowMount, createLocalVue, RouterLinkStub, mount } from '@vue/test-utils'
import Vuex from 'vuex'
import Header from '../../../app/javascript/views/layouts/Header.vue'
import VueRouter from 'vue-router';
import flushPromises from 'flush-promises'
import { cloneDeep } from "lodash";
import storeConfig from './../../../app/javascript/store'

const localVue = createLocalVue()
localVue.use(Vuex)
localVue.use(VueRouter);

jest.mock("../../../app/javascript/http", () => ({
    delete: jest.fn(() => Promise.resolve({ data: { message : 'ログアウトしました' } })),
}));

describe('Header', () => {
    describe('ログインしている場合', () => {
        let state
        let getters
        let actions
        let store
        let wrapper
        let testId = 1
        let testName = 'test'

        beforeEach(() => {

            const router = new VueRouter({
                routes: [
                  {
                    name: 'UserShow',
                    path: '/user/:id'
                  }
                ]
              });

            state = {
                userId: testId,
                userName: testName,
                login: true,
                message:'',
                errorsMessage:[]
            }

            getters = {
                stateUserId: () =>  state.userId,
                stateUserName: () =>  state.userName,  
                stateLogin: () =>  state.login,
                stateMessage: () => state.message,
                stateErrorsMessage: () => state.errorsMessage
            }

            actions = {
                setErrorsMessage: jest.fn(),
                setUserName: jest.fn(),
                setUserId: jest.fn(),
                setMessage: jest.fn(),
                login: jest.fn(),
            }
            
            store = new Vuex.Store(cloneDeep(storeConfig))
            // store = new Vuex.Store({
            //     state,
            //     getters,
            //     actions
            // })

            wrapper = shallowMount(Header, { store, localVue,
                stubs: {
                    RouterLink: RouterLinkStub
                  },
                  router,
            })
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
                const links = wrapper.findAll(RouterLinkStub)
                const userNameTag = links.at(1)
                expect(userNameTag.props().to.params.id).toBe(testId)
            })
        })

        describe('userName', () =>{
            it('戻り値が返却されること', () => {
                expect(wrapper.vm.userName).toBe(testName)
            })
            it('戻り値が描画されること', () => {
                const links = wrapper.findAll(RouterLinkStub)
                const userNameTag = links.at(1)
                expect(userNameTag.text()).toBe(testName)
            })
        })

        describe('logout', () =>{
            
            // beforeEach( async () => {
            //     wrapper.find('button').trigger('click')
            //     await flushPromises()
            // })
            // // モックを作る必要がある

            it('戻り値が返却されること', async () => {
                wrapper.find('button').trigger('click')
                await flushPromises()
                expect(actions.setErrorsMessage).toHaveBeenCalled()
            })
        })

        describe('router-linkのtoプロパティに値がセットされているか', () => {

            let links

            beforeEach(() => {
                links = wrapper.findAll(RouterLinkStub)
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
})

