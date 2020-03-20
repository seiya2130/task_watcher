require 'rails_helper'

RSpec.describe Task, type: :model do
    describe 'name' do
        let(:task) { build(:task, name: name) } 
        context '空白' do
            let(:name){ nil }
            it 'is invalid' do
                expect(task).to be_invalid
                expect(task.errors.messages[:name]).to include("を入力してください")
            end
        end
        context '21文字以上' do
            let(:name){ "a" * 21 }
            it 'is invalid' do
                expect(task).to be_invalid
                expect(task.errors.messages[:name]).to include("は20文字以内で入力してください")
            end
        end
    end
    describe 'dead_line' do
        let(:task) { build(:task, dead_line: dead_line) } 
        context '今日日付より前' do
            let(:dead_line){ Date.today - 1 }
            it 'is invalid' do
                expect(task).to be_invalid
                expect(task.errors.messages[:dead_line]).to include("は今日日付より後の日付を選択してください")
            end
        end
    end
    describe '成功' do
        let(:task) { build(:task) } 
        it 'is valid' do
            expect(task).to be_valid
        end
    end
end