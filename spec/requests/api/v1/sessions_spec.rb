require 'rails_helper'

RSpec.describe "Sessions", type: :request do
    describe 'POST #create' do
        let(:user){ create(:user) }
        context 'パラメーターが妥当な場合' do    
            it 'リクエストが成功すること' do
                post api_v1_sessions_path, params: { session: { email: user.email, password: user.password } }
                expect(response).to have_http_status(201)
            end
            it 'jsonに値がセットされること' do
                post api_v1_sessions_path, params: { session: { email: user.email, password: user.password } }
                json = JSON.parse(response.body)
                expect(json['user']['name']).to eq(user.name)
                expect(json['message']).to be_present
            end
        end
        context 'パラメーターが不正な場合' do
            it 'リクエストが成功すること' do
                post api_v1_sessions_path, params: { session: { email: "" , password: user.password } }
                expect(response).to have_http_status(400)
            end
            it 'エラーメッセージがセットされること' do
                post api_v1_sessions_path, params: { session: { email: "" , password: user.password } }
                json = JSON.parse(response.body)
                expect(json['errors']).to be_present
            end
        end
    end
    describe 'DELETE #destroy' do
        let(:user){ create(:user) }
        before do
            post api_v1_sessions_path, params: { session: { email: user.email, password: user.password } }
        end
        it 'リクエストが成功すること' do
            delete api_v1_session_path(user)
            expect(response).to have_http_status(200)
        end
        it 'jsonに値がセットされること' do
            delete api_v1_session_path(user)
            json = JSON.parse(response.body)
            expect(json['message']).to be_present
        end
    end
end