import { createLocalVue, mount } from '@vue/test-utils'
import Vuex from 'vuex'
import App from '../../app/javascript/app.vue'
import VueRouter from 'vue-router';
import flushPromises from 'flush-promises'
import { cloneDeep } from "lodash";
import storeConfig from '../../app/javascript/store'
import router from '../../app/javascript/router'
import MockAdapter from "axios-mock-adapter";
import http from '../../app/javascript/http'
import header from '../../app/javascript/views/layouts/header'
import message from '../../app/javascript/views/layouts/message'
import errorsMessage from '../../app/javascript/views/layouts/errorsMessage'
import top from '../../app/javascript/views/static_pages/top'

const localVue = createLocalVue()
localVue.use(Vuex)
localVue.use(VueRouter);
let store = undefined
let wrapper = undefined

const mockAxios = new MockAdapter(http);

describe('app', () => {

    beforeEach( async () => {
        
        store = new Vuex.Store(cloneDeep(storeConfig))

        wrapper = mount(App, { store, localVue,router})
    })

    describe('コンポーネントが含まれること', () => {

        it('Header',  () => {
            expect(wrapper.findComponent(header).exists()).toBeTruthly
        })

        it('Message',  () => {
            expect(wrapper.findComponent(message).exists()).toBeTruthly
        })

        it('ErrorsMessage',  () => {
            expect(wrapper.findComponent(errorsMessage).exists()).toBeTruthly
        })
        
    })

    describe('router-viewが機能していること', () => {

        it('router-view',  () => {
            expect(wrapper.findComponent(top).exists()).toBeTruthly
        })

    })

})
