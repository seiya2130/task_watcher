import { shallowMount, createLocalVue } from '@vue/test-utils'
import Vuex from 'vuex'
import ErrorsMessage from '../../../app/javascript/views/layouts/ErrorsMessage.vue'
import { cloneDeep } from "lodash";
import storeConfig from './../../../app/javascript/store'

const localVue = createLocalVue()
localVue.use(Vuex)
let store = undefined
let wrapper = undefined

describe('ErrorsMessage', () => {
    describe('メッセージがある場合', () => {

        let msg = 'エラーメッセージ'

        beforeEach(() => {
            store = new Vuex.Store(cloneDeep(storeConfig))
            store.state.errorsMessage.push(msg)
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

        beforeEach(() => {
            store = new Vuex.Store(cloneDeep(storeConfig))
            wrapper = shallowMount(ErrorsMessage, { store, localVue })
        })

        it('算出プロパティの戻り値が返却されること', () => {
            expect(wrapper.vm.existErrorsMessage).toBeFalsy()
        })

        it('メッセージがセットされないこと', () => {
            expect(wrapper.vm.errorsMessage).toEqual([])
        })

        it('メッセージが描画されないこと', () => {
            expect(wrapper.find('li').exists()).toBeFalsy
        })

    })
        
})

