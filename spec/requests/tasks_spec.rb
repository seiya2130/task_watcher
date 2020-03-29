require 'rails_helper'

RSpec.describe "TaskLists", type: :request do
    context 'ログインしている' do
        let(:user){ create(:user) }
        before do
            post login_path, params: { session: { email: user.email, password: user.password } }
        end
        describe 'GET #new' do
            let(:task_list){ user.task_lists.create(attributes_for(:task_list_request)) }
            it 'リクエストが成功すること' do
                get new_task_list_task_path(task_list)
                expect(response).to have_http_status(200)
            end
        end
        describe 'POST #create' do
            let(:task_list){ user.task_lists.create(attributes_for(:task_list_request)) }
            context 'パラメータが妥当な場合' do
                it 'リクエストが成功すること' do
                    post task_list_tasks_path(task_list), params: { task: attributes_for(:task_request) }
                    expect(response).to have_http_status(302)
                end
                it 'タスクが登録されること' do
                    expect do
                        post task_list_tasks_path(task_list), params: { task: attributes_for(:task_request) }
                    end.to change(Task, :count).by(1)
                end
                it 'メッセージがセットされること' do
                    post task_list_tasks_path(task_list), params: { task: attributes_for(:task_request) }
                    expect(flash[:notice]).to be_present
                end
                it 'リダイレクトすること' do
                    post task_list_tasks_path(task_list), params: { task: attributes_for(:task_request) }
                    expect(response).to redirect_to task_list_path(task_list)
                end
            end
            context 'パラメータが不正な場合' do
                it 'リクエストが成功すること' do
                    post task_list_tasks_path(task_list), params: { task: attributes_for(:task_request, name: nil ) }
                    expect(response).to have_http_status(200)
                end
                it 'タスクリストが登録されないこと' do
                    expect do
                        post task_list_tasks_path(task_list), params: { task: attributes_for(:task_request, name: nil ) }
                    end.not_to change(Task, :count)
                end
                it '画面が描画されること' do
                    post task_list_tasks_path(task_list), params: { task: attributes_for(:task_request, name: nil ) }
                    expect(response).to render_template(:new)
                end
                it 'エラーメッセージが表示されること' do
                    post task_list_tasks_path(task_list), params: { task: attributes_for(:task_request, name: nil ) }
                    expect(response.body).to include 'msg error'
                end
            end
        end
        describe 'GET #edit' do
            let(:task_list){ user.task_lists.create(attributes_for(:task_list_request)) }
            let(:task){ task_list.tasks.create(attributes_for(:task_request))}
            it 'リクエストが成功すること' do
                get edit_task_path(task)
                expect(response).to have_http_status(200)
            end
            it 'タスク名が表示されていること' do
                get edit_task_path(task)
                expect(response.body).to include task.name
            end
        end
        describe 'PUT #update' do
            let(:task_list){ user.task_lists.create(attributes_for(:task_list_request)) }
            let(:task){ task_list.tasks.create(attributes_for(:task_request))}
            context 'パラメータが妥当な場合' do
                it 'リクエストが成功すること' do
                    put task_path(task), params: { task: attributes_for(:task_request_update) }
                    expect(response).to have_http_status(302)
                end
                it 'タスク名が更新されること' do
                    expect do
                        put task_path(task), params: { task: attributes_for(:task_request_update) }
                    end.to change { Task.find(task.id).name }.from('test').to('test_')
                end
                it 'メッセージがセットされること' do
                    put task_path(task), params: { task: attributes_for(:task_request_update) }
                    expect(flash[:notice]).to be_present
                end
                it 'リダイレクトすること' do
                    put task_path(task), params: { task: attributes_for(:task_request_update) }
                    expect(response).to redirect_to task_list_path(task_list)
                end
            end
            context 'パラメータが不正な場合' do
                it 'リクエストが成功すること' do
                    put task_path(task), params: { task: attributes_for(:task_request_update, name: nil ) }
                    expect(response).to have_http_status(200)
                end
                it 'タスクリスト名が変更されないこと' do
                    expect do
                        put task_path(task), params: { task: attributes_for(:task_request_update, name: nil ) }
                    end.not_to change(Task.find(task.id), :name)
                end
                it '画面が描画されること' do
                    put task_path(task), params: { task: attributes_for(:task_request_update, name: nil ) }
                    expect(response).to render_template(:edit)
                end
                it 'エラーが表示されること' do
                    put task_path(task), params: { task: attributes_for(:task_request_update, name: nil ) }
                    expect(response.body).to include 'msg error'
                end
            end
        end
        describe 'DELETE #destroy' do
            let(:task_list){ user.task_lists.create(attributes_for(:task_list_request)) }
            let(:task){ task_list.tasks.create(attributes_for(:task_request))}
            it 'リクエストが成功すること' do
                delete task_list_path(task_list)
                expect(response).to have_http_status(302)
            end
            xit 'タスクが削除されること' do
                expect do
                    delete task_path(task)
                end.to change(Task, :count).by(-1)
            end
            it 'メッセージがセットされること' do
                delete task_path(task)
                expect(flash[:notice]).to be_present
            end
            it 'リダイレクトすること' do
                delete task_path(task)
                expect(response).to redirect_to task_list_path(task_list)
            end
        end
    end
    context '正しいユーザーではない' do
        describe 'GET #edit' do
            let(:user){ create(:user) }
            let(:user2){ create(:user, email:'test2@test2.com') }
            let(:task_list){ user.task_lists.create(attributes_for(:task_list_request)) }
            let(:task){ task_list.tasks.create(attributes_for(:task_request))}
            before do
                post login_path, params: { session: { email: user2.email, password: user2.password } }
            end
            it 'リクエストが成功すること' do
                get edit_task_path(task)
                expect(response).to have_http_status(302)
            end
            it 'メッセージがセットされること' do
                get edit_task_path(task)
                expect(flash[:danger]).to be_present
            end
            it 'リダイレクトすること' do
                get edit_task_path(task)
                expect(response).to redirect_to task_lists_path
            end
        end
    end
end