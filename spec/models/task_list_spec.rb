require 'rails_helper'

RSpec.describe TaskList, type: :model do
    describe 'name' do
        let(:task_list) { build(:task_list, name: name) } 
        context '空白' do
            let(:name){ nil }
            it 'is invalid' do
                expect(task_list).to be_invalid
                expect(task_list.errors.messages[:name]).to include("を入力してください")
            end
        end
        context '11文字以上' do
            let(:name){ "a" * 11 }
            it 'is invalid' do
                expect(task_list).to be_invalid
                expect(task_list.errors.messages[:name]).to include("は10文字以内で入力してください")
            end
        end
    end
    describe 'tasks' do
        let(:task_list) { create(:task_list) } 
        context 'タスクを複数持つ' do
            it 'is valid' do
                create(:task, task_list: task_list)
                create(:task, task_list: task_list)             
                expect(task_list.tasks.count).to eq 2
            end
        end
        context 'タスクリスト削除でタスクも削除' do
            it 'is valid' do
                create(:task, task_list: task_list)
                expect{task_list.destroy}.to change{Task.count}.by(-1)
            end
        end
    end
    describe '成功' do
        let(:task_list) { create(:task_list) } 
        it 'is valid' do
            expect(task_list).to be_valid
        end
    end
end