require 'rails_helper'

RSpec.describe "Tasks", type: :request do
    context 'ログインしている' do
        let(:user){ create(:user) }
        before do
            post api_v1_sessions_path, params: { session: { email: user.email, password: user.password } }
        end
        describe 'GET #new' do
            let(:task_list){ user.task_lists.create(attributes_for(:task_list_request)) }
            it 'リクエストが成功すること' do
                get new_api_v1_task_list_task_path(task_list)
                expect(response).to have_http_status(200)
            end
        end
        describe 'POST #create' do
            let(:task_list){ user.task_lists.create(attributes_for(:task_list_request)) }
            context 'パラメータが妥当な場合' do
                it 'リクエストが成功すること' do
                    post api_v1_task_list_tasks_path(task_list), params: { task: attributes_for(:task_request) }
                    expect(response).to have_http_status(200)
                end
                it 'タスクが登録されること' do
                    expect do
                        post api_v1_task_list_tasks_path(task_list), params: { task: attributes_for(:task_request) }
                    end.to change(Task, :count).by(1)
                end
                it 'jsonに値がセットされること' do
                    post api_v1_task_list_tasks_path(task_list), params: { task: attributes_for(:task_request) }
                    json = JSON.parse(response.body)
                    expect(json['message']).to be_present
                end
            end
            context 'パラメータが不正な場合' do
                it 'リクエストが成功すること' do
                    post api_v1_task_list_tasks_path(task_list), params: { task: attributes_for(:task_request, name: nil ) }
                    expect(response).to have_http_status(422)
                end
                it 'タスクリストが登録されないこと' do
                    expect do
                        post api_v1_task_list_tasks_path(task_list), params: { task: attributes_for(:task_request, name: nil ) }
                    end.not_to change(Task, :count)
                end
                it 'エラーメッセージがセットされること' do
                    post api_v1_task_list_tasks_path(task_list), params: { task: attributes_for(:task_request, name: nil ) }
                    json = JSON.parse(response.body)
                    expect(json['errors']).to be_present
                end
            end
        end
        describe 'GET #edit' do
            let(:task_list){ user.task_lists.create(attributes_for(:task_list_request)) }
            let(:task){ task_list.tasks.create(attributes_for(:task_request))}
            it 'リクエストが成功すること' do
                get edit_api_v1_task_path(task)
                expect(response).to have_http_status(200)
            end
            it 'jsonに値がセットされていること' do
                get edit_api_v1_task_path(task)
                json = JSON.parse(response.body)
                expect(json['id']).to eq(task.id)
            end
        end
        describe 'PUT #update' do
            let(:task_list){ user.task_lists.create(attributes_for(:task_list_request)) }
            let(:task){ task_list.tasks.create(attributes_for(:task_request))}
            context 'パラメータが妥当な場合' do
                it 'リクエストが成功すること' do
                    put api_v1_task_path(task), params: { task: attributes_for(:task_request_update) }
                    expect(response).to have_http_status(200)
                end
                it 'タスク名が更新されること' do
                    expect do
                        put api_v1_task_path(task), params: { task: attributes_for(:task_request_update) }
                    end.to change { Task.find(task.id).name }.from('test').to('test_')
                end
                it 'jsonに値がセットされること' do
                    put api_v1_task_path(task), params: { task: attributes_for(:task_request_update) }
                    json = JSON.parse(response.body)
                    expect(json['message']).to be_present
                end
            end
            context 'パラメータが不正な場合' do
                it 'リクエストが成功すること' do
                    put api_v1_task_path(task), params: { task: attributes_for(:task_request_update, name: nil ) }
                    expect(response).to have_http_status(422)
                end
                it 'タスクリスト名が変更されないこと' do
                    expect do
                        put api_v1_task_path(task), params: { task: attributes_for(:task_request_update, name: nil ) }
                    end.not_to change(Task.find(task.id), :name)
                end
                it 'エラーメッセージがセットされること' do
                    put api_v1_task_path(task), params: { task: attributes_for(:task_request_update, name: nil ) }
                    json = JSON.parse(response.body)
                    expect(json['errors']).to be_present
                end
            end
        end
        describe 'DELETE #destroy' do
            let(:task_list){ user.task_lists.create(attributes_for(:task_list_request)) }
            before do
                post api_v1_task_list_tasks_path(task_list), params: { task: attributes_for(:task_request) }
                @task= Task.find(1)
            end
            it 'リクエストが成功すること' do
                delete api_v1_task_path(@task)
                expect(response).to have_http_status(200)
            end
            it 'タスクが削除されること' do
                expect do
                    delete api_v1_task_path(@task)
                end.to change(Task, :count).by(-1)
            end
            it 'jsonに値がセットされること' do
                delete api_v1_task_path(@task)
                json = JSON.parse(response.body)
                expect(json['message']).to be_present
            end
        end
        describe 'GET #progress' do
            let(:task_list){ user.task_lists.create(attributes_for(:task_list_request)) }
            before do
                post api_v1_task_list_tasks_path(task_list), params: { task: attributes_for(:task_request) }
                post api_v1_task_list_tasks_path(task_list), params: { task: attributes_for(:task_request, name:'進行中タスク', status: 1) }
            end
            it 'リクエストが成功すること' do
                get api_v1_tasks_progress_path
                expect(response).to have_http_status(200)
            end
            it 'jsonに進行中タスクがセットされること' do
                get api_v1_tasks_progress_path
                json = JSON.parse(response.body)
                expect(json['task_lists']).to be_present
                expect(json['tasks'][0]['name']).to eq('進行中タスク')
            end
        end
    end
    context '権限がない' do
        describe 'GET #edit' do
            let(:user){ create(:user) }
            let(:user2){ create(:user, email:'test2@test2.com') }
            let(:task_list){ user.task_lists.create(attributes_for(:task_list_request)) }
            let(:task){ task_list.tasks.create(attributes_for(:task_request))}
            before do
                post api_v1_sessions_path, params: { session: { email: user2.email, password: user2.password } }
            end
            it 'リクエストが成功すること' do
                get edit_api_v1_task_path(task)
                expect(response).to have_http_status(401)
            end
            it 'メッセージがセットされること' do
                get edit_api_v1_task_path(task)
                json = JSON.parse(response.body)
                expect(json['errors']).to be_present
            end
        end
    end
end