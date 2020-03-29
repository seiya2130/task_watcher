require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
    describe 'GET #top' do
        it 'リクエストが成功すること' do
            get static_pages_top_path
            expect(response).to have_http_status(200)
        end
    end
    describe 'GET root' do
        it 'リクエストが成功すること' do
            get root_path
            expect(response).to have_http_status(200)
        end
    end
end