require 'rails_helper'
include SessionsHelper

RSpec.describe "TaskLists", type: :request do
    context 'ログインしている' do
        let(:user){ create(:user) }
        before do
            post api_v1_sessions_path, params: { session: { email: user.email, password: user.password } }
        end
        describe 'GET #index' do    
            it 'リクエストが成功すること' do
                get api_v1_task_lists_path
                expect(response).to have_http_status(200)
            end
            it 'jsonに値がセットされていること' do
                user.task_lists.create(attributes_for(:task_list_request))
                get api_v1_task_lists_path
                json = JSON.parse(response.body)
                expect(json[0]['user_id']).to eq(user.id)
            end
        end
        describe 'GET #new' do
            it 'リクエストが成功すること' do
                get new_api_v1_task_list_path
                expect(response).to have_http_status(200)
            end
        end
        describe 'GET #show' do
            context 'タスクリストが存在する場合' do
                let(:task_list){ user.task_lists.create(attributes_for(:task_list_request)) }
                it 'リクエストが成功すること' do
                    get api_v1_task_list_path(task_list)
                    expect(response).to have_http_status(200)
                end
                it 'jsonに値がセットされること' do
                    get api_v1_task_list_path(task_list)
                    json = JSON.parse(response.body)
                    expect(json).to include('taskList')
                    expect(json).to include('tasks')
                end
            end
            context 'タスクリストが存在しない場合' do
                subject { -> { get api_v1_task_list_path 1 } }
                it { is_expected.to raise_error NoMethodError }
            end
        end
        describe 'POST #create' do
            context 'パラメータが妥当な場合' do
                it 'リクエストが成功すること' do
                    post api_v1_task_lists_path, params: { task_list: attributes_for(:task_list_request) }
                    expect(response).to have_http_status(200)
                end
                it 'タスクリストが登録されること' do
                    expect do
                        post api_v1_task_lists_path, params: { task_list: attributes_for(:task_list_request) }
                    end.to change(TaskList, :count).by(1)
                end
                it 'jsonに値がセットされること' do
                    post api_v1_task_lists_path, params: { task_list: attributes_for(:task_list_request) }
                    json = JSON.parse(response.body)
                    expect(json['message']).to be_present
                end
            end
            context 'パラメータが不正な場合' do
                it 'リクエストが成功すること' do
                    post api_v1_task_lists_path, params: { task_list: attributes_for(:task_list_request, name: nil) }
                    expect(response).to have_http_status(422)
                end
                it 'タスクリストが登録されないこと' do
                    expect do
                        post api_v1_task_lists_path, params: { task_list: attributes_for(:task_list_request, name: nil) }
                    end.not_to change(TaskList, :count)
                end
                it 'エラーメッセージがセットされること' do
                    post api_v1_task_lists_path, params: { task_list: attributes_for(:task_list_request, name: nil) }
                    json = JSON.parse(response.body)
                    expect(json['errors']).to be_present
                end
            end
        end
        describe 'PUT #update' do
            let(:task_list){ user.task_lists.create(attributes_for(:task_list_request)) }
            context 'パラメータが妥当な場合' do
                it 'リクエストが成功すること' do
                    put api_v1_task_list_path(task_list), params: { task_list: attributes_for(:task_list_request_update) }
                    expect(response).to have_http_status(200)
                end
                it 'タスクリスト名が更新されること' do
                    expect do
                        put api_v1_task_list_path(task_list), params: { task_list: attributes_for(:task_list_request_update) }
                    end.to change { TaskList.find(task_list.id).name }.from('test').to('test_')
                end
                it 'jsonに値がセットされること' do
                    put api_v1_task_list_path(task_list), params: { task_list: attributes_for(:task_list_request_update) }
                    json = JSON.parse(response.body)
                    expect(json['message']).to be_present
                end
            end
            context 'パラメータが不正な場合' do
                it 'リクエストが成功すること' do
                    put api_v1_task_list_path(task_list), params: { task_list: attributes_for(:task_list_request_update, name: nil) }
                    expect(response).to have_http_status(422)
                end
                it 'タスクリスト名が変更されないこと' do
                    expect do
                        put api_v1_task_list_path(task_list), params: { task_list: attributes_for(:task_list_request_update, name: nil) }
                    end.not_to change(TaskList.find(task_list.id), :name)
                end
                it 'エラーメッセージがセットされること' do
                    put api_v1_task_list_path(task_list), params: { task_list: attributes_for(:task_list_request_update, name: nil) }
                    json = JSON.parse(response.body)
                    expect(json['errors']).to be_present
                end
            end
        end
        describe 'DELETE #destroy' do
            before do
                post api_v1_task_lists_path, params: { task_list: attributes_for(:task_list_request) }
                @task_list = TaskList.find(1)
            end
            it 'リクエストが成功すること' do
                delete api_v1_task_list_path(@task_list)
                expect(response).to have_http_status(200)
            end
            it 'タスクリストが削除されること' do
                expect do
                    delete api_v1_task_list_path(@task_list)
                end.to change(TaskList, :count).by(-1)
            end
            it 'jsonに値がセットされること' do
                delete api_v1_task_list_path(@task_list)
                json = JSON.parse(response.body)
                expect(json['message']).to be_present
            end
        end
    end
    context 'ログインしていない' do
        describe 'GET #new' do
            it 'リクエストが成功すること' do
                get new_api_v1_task_list_path
                expect(response).to have_http_status(401)
            end
            it 'メッセージがセットされること' do
                get new_api_v1_task_list_path
                json = JSON.parse(response.body)
                expect(json['errors']).to be_present
            end
        end
    end
    context '権限がない' do
        describe 'GET #show' do
            let(:user){ create(:user) }
            let(:user2){ create(:user, email:'test2@test2.com') }
            let(:task_list){ user.task_lists.create(attributes_for(:task_list_request)) }
            before do
                post api_v1_sessions_path, params: { session: { email: user2.email, password: user2.password } }
            end
            it 'リクエストが成功すること' do
                get api_v1_task_list_path(task_list)
                expect(response).to have_http_status(401)
            end
            it 'メッセージがセットされること' do
                get api_v1_task_list_path(task_list)
                json = JSON.parse(response.body)
                expect(json['errors']).to be_present
            end
        end
    end
end