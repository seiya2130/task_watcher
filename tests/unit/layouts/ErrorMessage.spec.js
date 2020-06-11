import { shallowMount, createLocalVue } from '@vue/test-utils'
import Vuex from 'vuex'
import ErrorsMessage from '../../../app/javascript/views/layouts/ErrorsMessage.vue'

const localVue = createLocalVue()
localVue.use(Vuex)

describe('ErrorsMessage', () => {
    describe('メッセージがある場合', () => {
        let state
        let getters
        let store       
        let wrapper 
        let msg = 'エラーメッセージ'
        

        beforeEach(() => {
            state = {
                errorsMessage:[msg]
            }

            getters = {
                stateErrorsMessage: () => state.errorsMessage
            }
      
            store = new Vuex.Store({
                state,
                getters
            })

            wrapper = shallowMount(ErrorsMessage, { store, localVue })
        })

        it('算出プロパティの戻り値が返却されること', () => {
            expect(wrapper.vm.existErrorsMessage).toBeTruthy()
        })

        it('メッセージがセットされること', () => {
            expect(wrapper.vm.errorsMessage[0]).toBe(msg)
        })

        it('メッセージが描画されること', () => {
            expect(wrapper.find('li').text()).toBe(msg)
        })

    })

    describe('メッセージがない場合', () => {
        let state
        let getters
        let store       
        let wrapper 
        

        beforeEach(() => {
            state = {
                errorsMessage:[]
            }

            getters = {
                stateErrorsMessage: () => state.errorsMessage
            }
      
            store = new Vuex.Store({
                state,
                getters
            })

            wrapper = shallowMount(ErrorsMessage, { store, localVue })
        })

        it('算出プロパティの戻り値が返却されること', () => {
            expect(wrapper.vm.existErrorsMessage).toBeFalsy()
        })

        it('メッセージがセットされないこと', () => {
            expect(wrapper.vm.errorsMessage.length).toBe(0)
        })

        it('メッセージが描画されないこと', () => {
            expect(wrapper.contains('li')).toBeFalsy()
        })

    })
        
})

