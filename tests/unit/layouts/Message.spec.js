import { shallowMount, createLocalVue } from '@vue/test-utils'
import Vuex from 'vuex'
import Message from '../../../app/javascript/views/layouts/Message.vue'

const localVue = createLocalVue()
localVue.use(Vuex)

describe('Message', () => {
    describe('メッセージがある場合', () => {
        let getters
        let store        
        let msg = 'メッセージ'
        let wrapper

        beforeEach(() => {
            getters = {
              stateMessage: () => msg
            }
      
            store = new Vuex.Store({
              getters
            })

            wrapper = shallowMount(Message, { store, localVue })
        })

        it('算出プロパティの戻り値が返却されること', () => {
            expect(wrapper.vm.existMessage).toBeTruthy()
        })

        it('メッセージがセットされること', () => {
            expect(wrapper.vm.message).toBe(msg)
        })

        it('メッセージが描画されること', () => {
            expect(wrapper.find('span').text()).toBe(msg)
        })

    })

    describe('メッセージがない場合', () => {
        let getters
        let store        
        let msg = ''
        let wrapper

        beforeEach(() => {
            getters = {
              stateMessage: () => msg
            }
      
            store = new Vuex.Store({
              getters
            })

            wrapper = shallowMount(Message, { store, localVue })
        })

        it('算出プロパティの戻り値が返却されること', () => {
            expect(wrapper.vm.existMessage).toBeFalsy()
        })

        it('メッセージがセットされること', () => {
            expect(wrapper.vm.message).toBe(msg)
        })

        it('メッセージが描画されないこと', () => {
            expect(wrapper.contains('span')).toBeFalsy()
        })
        
    })


        
})

