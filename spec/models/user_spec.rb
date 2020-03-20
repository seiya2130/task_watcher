require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'name' do   
    let(:user) { build(:user, name: name) }  
    context '空白' do
      let(:name){ nil }
      it 'is invalid' do 
        expect(user).to be_invalid
        expect(user.errors.messages[:name]).to include("を入力してください")
      end
    end
    context '51文字以上' do 
      let(:name){ "a" * 51 }
      it 'is invalid' do 
        expect(user).to be_invalid
        expect(user.errors.messages[:name]).to include("は50文字以内で入力してください")
      end
    end
  end
  describe 'email' do
    let(:user) { build(:user, email: email) }  
    context '空白' do
      let(:email){ nil }
      it 'is invalid' do 
        expect(user).to be_invalid
        expect(user.errors.messages[:email]).to include("を入力してください")
      end
    end
    context '255文字以上' do 
      let(:email){ "a" * 247  + "@test.com" }
      it 'is invalid' do 
        expect(user).to be_invalid
        expect(user.errors.messages[:email]).to include("は255文字以内で入力してください")
      end
    end
    context 'メールフォーマットが不正' do
      context '@の前に英数字、アンスコ(_)、記号(+,-,.)がない' do
        let(:email){ "@test.com" }
        it 'is invalid' do
          expect(user).to be_invalid
          expect(user.errors.messages[:email]).to include("は不正な値です")
        end
      end
      context '@がない' do
        let(:email){ "testtest.com" }
        it 'is invalid' do
          expect(user).to be_invalid
          expect(user.errors.messages[:email]).to include("は不正な値です")
        end
      end
      context '@の後に英数字、アンスコ(_)、記号(+,-,.)がない' do
        let(:email){ "test@.com" }
        it 'is invalid' do
          expect(user).to be_invalid
          expect(user.errors.messages[:email]).to include("は不正な値です")
        end
      end
      context '@の後の文字列の後に.(ドット)がない' do
        let(:email){ "test@testcom" }
        it 'is invalid' do
          expect(user).to be_invalid
          expect(user.errors.messages[:email]).to include("は不正な値です")
        end
      end
      context '@の後の文字列の後に.(ドット)がない' do
        let(:email){ "test@testcom" }
        it 'is invalid' do
          expect(user).to be_invalid
          expect(user.errors.messages[:email]).to include("は不正な値です")
        end
      end
      context '.(ドット)の後に数字がある' do
        let(:email){ "test@test.com1" }
        it 'is invalid' do
          expect(user).to be_invalid
          expect(user.errors.messages[:email]).to include("は不正な値です")
        end
      end
    end
    context '一意ではない' do
      let(:email){ "test@test.com" }
      it 'is invalid' do
        create(:user)
        expect(user).to be_invalid
        expect(user.errors.messages[:email]).to include("はすでに存在します")
      end
    end
  end
  describe 'password' do
    let(:user) { build(:user, password: password) }  
    context '空白' do
      let(:password){ nil }
      it 'is invalid' do
        expect(user).to be_invalid
        expect(user.errors.messages[:password]).to include("を入力してください")
      end
    end
    context '6文字未満' do
      let(:password){ "aaaaa" }
      it 'is invalid' do
        expect(user).to be_invalid
        expect(user.errors.messages[:password]).to include("は6文字以上で入力してください")
      end
    end
    context '暗号化' do
      let(:password){ "password" }
      it 'is valid' do
        expect(user).to be_valid
        expect(user.password_digest == "password" ).to be_falsey
      end
    end
  end
  describe 'task_lists' do
    let(:user) { build(:user) }
    context 'タスクリストを複数持つ' do
      it 'is valid' do
        create(:task_list, user: user)
        create(:task_list, user: user)
        expect(user.task_lists.count).to eq 2
      end  
    end
    context 'ユーザー削除でタスクリストも削除' do
      it 'is valid' do
        create(:task_list, user: user)
        expect{user.destroy}.to change{TaskList.count}.by(-1)
      end
    end
  end
  describe '成功' do
    let(:user) { create(:user) }
    it 'is vaid' do
      expect(user).to be_valid
    end
  end
end