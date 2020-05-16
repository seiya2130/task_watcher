require 'rails_helper'

RSpec.describe "Users", type: :request do
    context 'ログインしている' do
        describe 'GET #show' do 
            before do
                post api_v1_users_path, params: { user: attributes_for(:user) }
                @user = User.find(1)
            end
            context 'ユーザーが存在する場合' do
                it 'リクエストが成功すること' do
                    get api_v1_user_path(@user)
                    expect(response).to have_http_status(200)
                end
                it 'ユーザ名が表示されていること' do
                    get api_v1_user_path(@user)
                    json = JSON.parse(response.body)
                    expect(json['name']).to eq(@user.name)
                end
            end
            context 'ユーザーが存在しない場合' do
                subject { -> { get api_v1_user_path 2 } }
                it { is_expected.to raise_error(NoMethodError) }
            end
            context '権限がない場合' do
                it 'エラーメッセージがセットされること' do
                    create(:user2)
                    get api_v1_user_path(2)
                    json = JSON.parse(response.body)
                    expect(json['errors']).to include('権限がありません')
                end
            end
        end
        describe 'PATCH #update' do
            before do
                post api_v1_users_path, params: { user: attributes_for(:user) }
                @user = User.find(1)
            end
            context 'パラメータが妥当な場合' do
                it 'リクエストが成功すること' do
                    patch api_v1_user_path(@user), params: { user: attributes_for(:user2) }
                    expect(response).to have_http_status(200)
                end
                it 'ユーザー名が更新されること' do
                    expect { 
                        patch api_v1_user_path(@user), params: { user: attributes_for(:user2) }
                    }.to change { User.find(@user.id).name}.from('test').to('test2')
                end
                it 'jsonに値がセットされること' do
                    patch api_v1_user_path(@user), params: { user: attributes_for(:user2) }
                    json = JSON.parse(response.body)
                    expect(json['user']).to be_present
                    expect(json['message']).to be_present
                end
            end
            context 'パラメータが不正な場合' do
                it 'リクエストが成功すること' do
                    patch api_v1_user_path(@user), params: { user: attributes_for(:user2, name: nil) }
                    expect(response).to have_http_status(422)
                end
                it 'ユーザー名が変更されないこと' do
                    expect { 
                        patch api_v1_user_path(@user), params: { user: attributes_for(:user2, name: nil) }
                    }.not_to change { User.find(@user.id)}
                end
                it 'エラーメッセージがセットされること' do
                    patch api_v1_user_path(@user), params: { user: attributes_for(:user2, name: nil) }
                    json = JSON.parse(response.body)
                    expect(json['errors']).to be_present
                end
            end
        end
    end
    context 'ログインしていない' do
        describe 'POST #create' do
            before do
                @user = User.new(attributes_for(:user))
            end
            context 'パラメーターが妥当な場合' do
                it 'リクエストが成功すること' do
                    post api_v1_users_path, params: { user: attributes_for(:user) }
                    expect(response).to have_http_status(201)
                end
                it 'ユーザが登録されていること' do
                    expect { 
                        post api_v1_users_path, params: { user: attributes_for(:user) }
                    }.to change { User.count }.by(1)
                end
                it 'jsonに値がセットされること' do
                    post api_v1_users_path, params: { user: attributes_for(:user) }
                    json = JSON.parse(response.body)
                    expect(json['user']['name']).to eq(@user.name)
                    expect(json['message']).to be_present
                end
            end
            context 'パラメーターが不正な場合' do
                it 'リクエストが成功すること' do
                    post api_v1_users_path, params: { user: attributes_for(:user, name: nil) }
                    expect(response).to have_http_status(422)
                end
                it 'ユーザーが登録されないこと' do
                    expect { 
                        post api_v1_users_path, params: { user: attributes_for(:user, name: nil) }
                    }.not_to change { User.count }
                end
                it 'エラーメッセージがセットされること' do
                    post api_v1_users_path, params: { user: attributes_for(:user, name: nil) }
                    json = JSON.parse(response.body)
                    expect(json).to include('errors');    
                end
            end
        end
        describe 'GET #show' do 
            it 'エラーメッセージがセットされること' do
                get api_v1_user_path(1)
                json = JSON.parse(response.body)
                expect(json).to include('errors'); 
                binding.pry 
            end
        end
    end
end
