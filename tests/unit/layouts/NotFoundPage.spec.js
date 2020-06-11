import { shallowMount } from '@vue/test-utils'
import NotFoundPage from '../../../app/javascript/views/layouts/NotFoundPage.vue'

describe('NotFoundPage', ()=> {
    it('メッセージが描画されること', ()=> {
        let msg ='NotFound'
        const wrapper = shallowMount(NotFoundPage)
        expect(wrapper.find('h1').text()).toMatch(msg) 
    })
})