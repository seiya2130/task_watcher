require 'rails_helper'

RSpec.describe "Sessions", type: :request do
    describe 'GET #new' do
        it 'リクエストが成功すること' do
            get login_path
            expect(response).to have_http_status(200)
        end
    end
    describe 'POST #create' do
        let(:user){ create(:user) }
        context 'パラメーターが妥当な場合' do    
            it 'リクエストが成功すること' do
                post login_path, params: { session: { email: user.email, password: user.password } }
                expect(response).to have_http_status(302)
            end
            it 'メッセージがセットされること' do
                post login_path, params: { session: { email: user.email, password: user.password } }
                expect(flash[:notice]).to be_present
            end
            it 'リダイレクトすること' do
                post login_path, params: { session: { email: user.email, password: user.password } }
                expect(response).to redirect_to User.last
            end
        end
        context 'パラメーターが不正な場合' do
            it 'リクエストが成功すること' do
                post login_path, params: { session: { email: "" , password: user.password } }
                expect(response).to have_http_status(200)
            end
            it 'メッセージがセットされること' do
                post login_path, params: { session: { email: "" , password: user.password } }
                expect(flash[:danger]).to be_present
            end
            it '画面が描画されること' do
                post login_path, params: { session: { email: "" , password: user.password } }
                expect(response).to render_template(:new)
            end
            it 'エラーが表示されること' do
                post login_path, params: { session: { email: "" , password: user.password } }
                expect(response.body).to include 'msg error'
            end
        end
    end
    describe 'DELETE #logout' do
        let(:user){ create(:user) }
        before do
            post login_path, params: { session: { email: user.email, password: user.password } }
        end
        it 'リクエストが成功すること' do
            delete logout_path
            expect(response).to have_http_status(302)
        end
        it 'メッセージがセットされること' do
            delete logout_path
            expect(flash[:notice]).to be_present
        end
        it 'リダイレクトすること' do
            delete logout_path
            expect(response).to redirect_to root_path
        end
    end
    describe 'POST #guset_login' do
        it 'リクエストが成功すること' do
            post guest_login_path
            expect(response).to have_http_status(302)
        end
        it 'メッセージがセットされること' do
            post guest_login_path
            expect(flash[:notice]).to be_present
        end
        it 'リダイレクトすること' do
            post guest_login_path
            expect(response).to redirect_to User.last
        end
    end
end