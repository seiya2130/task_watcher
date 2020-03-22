require 'rails_helper'

RSpec.describe "Users", type: :request do
    describe 'GET #new' do
        it 'リクエストが成功すること' do
            get signup_path
            expect(response).to have_http_status(200)
        end
    end
    describe 'POST #create' do
        context 'パラメーターが妥当な場合' do
            it 'リクエストが成功すること' do
                post signup_path, params: { user: attributes_for(:user) }
                expect(response).to have_http_status(302)
            end
            it 'ユーザが登録されていること' do
                expect { 
                    post signup_path, params: { user: attributes_for(:user) }
                }.to change { User.count }.by(1)
            end
            it 'メッセージがセットされること' do
                post signup_path, params: { user: attributes_for(:user) }
                expect(flash[:notice]).to be_present
            end
            it 'リダイレクトすること' do
                post signup_path, params: { user: attributes_for(:user) }
                expect(response).to redirect_to User.last
            end
        end
        context 'パラメーターが不正な場合' do
            it 'リクエストが成功すること' do
                post signup_path, params: { user: attributes_for(:user, name: nil) }
                expect(response).to have_http_status(200)
            end
            it 'ユーザーが登録されないこと' do
                expect { 
                    post signup_path, params: { user: attributes_for(:user,name: nil) }
                }.not_to change { User.count }
            end
            it '画面が描画されること' do
                post signup_path, params: { user: attributes_for(:user,name: nil) }
                expect(response).to render_template(:new)
            end
            it 'エラーが表示されること' do
                post signup_path, params: { user: attributes_for(:user,name: nil) }
                expect(response.body).to include 'msg error'
            end
        end
    end
    describe 'GET #show' do
        context 'ユーザーが存在する場合' do
            let(:user){ create(:user) }
            it 'リクエストが成功すること' do
                get user_path(user)
                expect(response).to have_http_status(200)
            end
            it 'ユーザ名が表示されていること' do
                get user_path(user)
                expect(response.body).to include user.name
            end
        end
        context 'ユーザーが存在しない場合' do
            subject { -> { get user_url 1 } }
            it { is_expected.to raise_error ActiveRecord::RecordNotFound }
        end
    end
    describe 'GET #edit' do
        let(:user) { create(:user) }
        it 'リクエストが成功すること' do
            get edit_user_url(user)
            expect(response).to have_http_status(200)
        end
        it 'ユーザー名が表示されていること' do
            get edit_user_url(user)
            expect(response.body).to include user.name
        end
        it 'メールアドレスが表示されていること' do
            get edit_user_url(user)
            expect(response.body).to include user.email
        end
    end
    describe 'PUT #update' do
        let(:user) { create(:user) }
        context 'パラメータが妥当な場合' do
            it 'リクエストが成功すること' do
                put user_path(user), params: { user: attributes_for(:user2) }
                expect(response).to have_http_status(302)
            end
            it 'ユーザー名が更新されること' do
                expect { 
                    put user_path(user), params: { user: attributes_for(:user2) }
                }.to change { User.find(user.id).name}.from('test').to('test2')
            end
            it 'メッセージがセットされること' do
                put user_path(user), params: { user: attributes_for(:user2) }
                expect(flash[:notice]).to be_present
            end
            it 'リダイレクトすること' do
                put user_path(user), params: { user: attributes_for(:user2) }
                expect(response).to redirect_to User.last
            end
        end
        context 'パラメータが不正な場合' do
            it 'リクエストが成功すること' do
                put user_path(user), params: { user: attributes_for(:user2, name: nil) }
                expect(response).to have_http_status(200)
            end
            it 'ユーザー名が変更されないこと' do
                expect { 
                    put user_path(user), params: { user: attributes_for(:user2, name: nil) }
                }.not_to change { User.find(user.id)}
            end
            it '画面が描画されること' do
                put user_path(user), params: { user: attributes_for(:user2, name: nil) }
                expect(response).to render_template(:edit)
            end
            it 'エラーが表示されること' do
                put user_path(user), params: { user: attributes_for(:user2, name: nil) }
                expect(response.body).to include 'msg error'
            end
        end
    end
end
