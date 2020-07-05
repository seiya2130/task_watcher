import { shallowMount, createLocalVue } from '@vue/test-utils'
import Message from '../../../app/javascript/views/layouts/Message.vue'
import Vuex from 'vuex'
import { cloneDeep } from "lodash";
import storeConfig from './../../../app/javascript/store'

const localVue = createLocalVue()
localVue.use(Vuex)
let store = undefined
let wrapper = undefined

describe('Message', () => {
    describe('メッセージがある場合', () => {
        
        let msg = 'メッセージ'

        beforeEach(() => {
            store = new Vuex.Store(cloneDeep(storeConfig))
            store.state.message = msg
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

        beforeEach(() => {
            store = new Vuex.Store(cloneDeep(storeConfig))
            wrapper = shallowMount(Message, { store, localVue })
        })

        it('算出プロパティの戻り値が返却されること', () => {
            expect(wrapper.vm.existMessage).toBeFalsy()
        })

        it('メッセージがセットされないこと', () => {
            expect(wrapper.vm.message).toBe('')
        })

        it('メッセージが描画されないこと', () => {
            expect(wrapper.find('span').exists()).toBeFalsy
        })

    })
        
})

