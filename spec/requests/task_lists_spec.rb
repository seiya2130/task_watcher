require 'rails_helper'
include SessionsHelper

RSpec.describe "TaskLists", type: :request do
    context 'ログインしている' do
        let(:user){ create(:user) }
        before do
            post login_path, params: { session: { email: user.email, password: user.password } }
        end
        describe 'GET #index' do    
            it 'リクエストが成功すること' do
                get task_lists_path
                expect(response).to have_http_status(200)
            end
            it 'ユーザー名が表示されていること' do
                get task_lists_path
                expect(response.body).to include user.name
            end
        end
        describe 'GET #show' do
            context 'タスクリストが存在する場合' do
                let(:task_list){ user.task_lists.create(attributes_for(:task_list_request)) }
                it 'リクエストが成功すること' do
                    get task_list_path(task_list)
                    expect(response).to have_http_status(200)
                end
                it 'タスクリスト名が表示されていること' do
                    get task_list_path(task_list)
                    expect(response.body).to include task_list.name
                end
            end
            context 'タスクリストが存在しない場合' do
                subject { -> { get task_list_path 1 } }
                it { is_expected.to raise_error NoMethodError }
            end
        end
        describe 'GET #new' do
            it 'リクエストが成功すること' do
                get new_task_list_path
                expect(response).to have_http_status(200)
            end
        end
        describe 'POST #create' do
            context 'パラメータが妥当な場合' do
                it 'リクエストが成功すること' do
                    post task_lists_path, params: { task_list: attributes_for(:task_list_request) }
                    expect(response).to have_http_status(302)
                end
                it 'タスクリストが登録されること' do
                    expect do
                        post task_lists_path, params: { task_list: attributes_for(:task_list_request) }
                    end.to change(TaskList, :count).by(1)
                end
                it 'メッセージがセットされること' do
                    post task_lists_path, params: { task_list: attributes_for(:task_list_request) }
                    expect(flash[:notice]).to be_present
                end
                it 'リダイレクトすること' do
                    post task_lists_path, params: { task_list: attributes_for(:task_list_request) }
                    expect(response).to redirect_to task_lists_path
                end
            end
            context 'パラメータが不正な場合' do
                it 'リクエストが成功すること' do
                    post task_lists_path, params: { task_list: attributes_for(:task_list_request, name: nil) }
                    expect(response).to have_http_status(200)
                end
                it 'タスクリストが登録されないこと' do
                    expect do
                        post task_lists_path, params: { task_list: attributes_for(:task_list_request, name: nil) }
                    end.not_to change(TaskList, :count)
                end
                it '画面が描画されること' do
                    post task_lists_path, params: { task_list: attributes_for(:task_list_request, name: nil) }
                    expect(response).to render_template(:new)
                end
                it 'エラーメッセージが表示されること' do
                    post task_lists_path, params: { task_list: attributes_for(:task_list_request, name: nil) }
                    expect(response.body).to include 'msg error'
                end
            end
        end
        describe 'GET #edit' do
            let(:task_list){ user.task_lists.create(attributes_for(:task_list_request)) }
            it 'リクエストが成功すること' do
                get edit_task_list_path(task_list)
                expect(response).to have_http_status(200)
            end
            it 'タスクリスト名が表示されていること' do
                get edit_task_list_path(task_list)
                expect(response.body).to include task_list.name
            end
        end
        describe 'PUT #update' do
            let(:task_list){ user.task_lists.create(attributes_for(:task_list_request)) }
            context 'パラメータが妥当な場合' do
                it 'リクエストが成功すること' do
                    put task_list_path(task_list), params: { task_list: attributes_for(:task_list_request_update) }
                    expect(response).to have_http_status(302)
                end
                it 'タスクリスト名が更新されること' do
                    expect do
                        put task_list_path(task_list), params: { task_list: attributes_for(:task_list_request_update) }
                    end.to change { TaskList.find(task_list.id).name }.from('test').to('test_')
                end
                it 'メッセージがセットされること' do
                    put task_list_path(task_list), params: { task_list: attributes_for(:task_list_request_update) }
                    expect(flash[:notice]).to be_present
                end
                it 'リダイレクトすること' do
                    put task_list_path(task_list), params: { task_list: attributes_for(:task_list_request_update) }
                    expect(response).to redirect_to task_lists_path
                end
            end
            context 'パラメータが不正な場合' do
                it 'リクエストが成功すること' do
                    put task_list_path(task_list), params: { task_list: attributes_for(:task_list_request_update, name: nil) }
                    expect(response).to have_http_status(200)
                end
                it 'タスクリスト名が変更されないこと' do
                    expect do
                        put task_list_path(task_list), params: { task_list: attributes_for(:task_list_request_update, name: nil) }
                    end.not_to change(TaskList.find(task_list.id), :name)
                end
                it '画面が描画されること' do
                    put task_list_path(task_list), params: { task_list: attributes_for(:task_list_request_update, name: nil) }
                    expect(response).to render_template(:edit)
                end
                it 'エラーが表示されること' do
                    put task_list_path(task_list), params: { task_list: attributes_for(:task_list_request_update, name: nil) }
                    expect(response.body).to include 'msg error'
                end
            end
            describe 'DELETE #destroy' do
                let(:task_list){ user.task_lists.create(attributes_for(:task_list_request)) }
                it 'リクエストが成功すること' do
                    delete task_list_path(task_list)
                    expect(response).to have_http_status(302)
                end
                xit 'タスクリストが削除されること' do
                    expect do
                        delete task_list_path(task_list)
                    end.to change(TaskList, :count).by(-1)
                end
                it 'メッセージがセットされること' do
                    delete task_list_path(task_list)
                    expect(flash[:notice]).to be_present
                end
                it 'リダイレクトすること' do
                    delete task_list_path(task_list)
                    expect(response).to redirect_to task_lists_path
                end
            end
        end
    end
    context 'ログインしていない' do
        describe 'GET #new' do
            it 'リクエストが成功すること' do
                get new_task_list_path
                expect(response).to have_http_status(302)
            end
            it 'メッセージがセットされること' do
                get new_task_list_path
                expect(flash[:danger]).to be_present
            end
            it 'リダイレクトすること' do
                get new_task_list_path
                expect(response).to redirect_to login_path
            end
        end
    end
    context '正しいユーザーではない' do
        describe 'GET #edit' do
            let(:user){ create(:user) }
            let(:user2){ create(:user, email:'test2@test2.com') }
            let(:task_list){ user.task_lists.create(attributes_for(:task_list_request)) }
            before do
                post login_path, params: { session: { email: user2.email, password: user2.password } }
            end
            it 'リクエストが成功すること' do
                get edit_task_list_path(task_list)
                expect(response).to have_http_status(302)
            end
            it 'メッセージがセットされること' do
                get edit_task_list_path(task_list)
                expect(flash[:danger]).to be_present
            end
            it 'リダイレクトすること' do
                get edit_task_list_path(task_list)
                expect(response).to redirect_to task_lists_path
            end
        end
    end
end