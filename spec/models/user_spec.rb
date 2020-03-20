require 'rails_helper'

RSpec.describe User, type: :model do
    describe 'name' do     
      it '空白' do 
        user = build(:user, name: nil)
        expect(user).to be_invalid
        expect(user.errors.messages[:name]).to include("を入力してください")
      end
      it '50文字以上' do 
        user = build(:user, name: "a" * 51)
        expect(user).to be_invalid
        expect(user.errors.messages[:name]).to include("は50文字以内で入力してください")
      end
    end
    describe 'email' do        
      it '空白' do 
        user = build(:user, email: nil)
        expect(user).to be_invalid
        expect(user.errors.messages[:email]).to include("を入力してください")
      end
      it '255文字以上' do 
        user = build(:user, email: "a" * 247  + "@test.com")
        expect(user).to be_invalid
        expect(user.errors.messages[:email]).to include("は255文字以内で入力してください")
      end
      describe 'メールフォーマットが不正' do
        it '@の前に英数字、アンスコ(_)、記号(+,-,.)がない' do
          user = build(:user, email: "@test.com")
          expect(user).to be_invalid
          expect(user.errors.messages[:email]).to include("は不正な値です")
        end
        it '@がない' do
          user = build(:user, email: "testtest.com")
          expect(user).to be_invalid
          expect(user.errors.messages[:email]).to include("は不正な値です")
        end
        it '@の後に英数字、アンスコ(_)、記号(+,-,.)がない' do
          user = build(:user, email: "test@.com")
          expect(user).to be_invalid
          expect(user.errors.messages[:email]).to include("は不正な値です")
        end
        it '@の後の文字列の後に.(ドット)がない' do
          user = build(:user, email: "test@.com")
          expect(user).to be_invalid
          expect(user.errors.messages[:email]).to include("は不正な値です")
        end
        it '.(ドット)の後に数字がある' do
          user = build(:user, email: "test@test.com1")
          expect(user).to be_invalid
          expect(user.errors.messages[:email]).to include("は不正な値です")
        end
      end
      it '一意ではない' do
        user_a = create(:user)
        user_b = build(:user)
        expect(user_b).to be_invalid
        expect(user_b.errors.messages[:email]).to include("はすでに存在します")
      end
    end
    describe 'password' do
      it '空白' do
        user = build(:user, password: nil)
        expect(user).to be_invalid
        expect(user.errors.messages[:password]).to include("を入力してください")
      end
      it '6文字未満' do
        user = build(:user, password: "aaaaa")
        expect(user).to be_invalid
        expect(user.errors.messages[:password]).to include("は6文字以上で入力してください")
      end
      it '暗号化' do
        user = create(:user)
        password = "password"
        expect(user.password_digest == password ).to be_falsey
      end
    end
    describe 'task_lists' do
      it '複数タスクリストを持つ' do
        user = create(:user)
        create(:task_list, user: user)
        create(:task_list, user: user)
        expect(user.task_lists.count).to eq 2
      end  
      it 'ユーザー削除でタスクリストも削除' do
        user = create(:user)
        task_list = create(:task_list, user: user)
        expect{user.destroy}.to change{TaskList.count}.by(-1)
      end
    end 
  it '成功' do
    user = create(:user)
    expect(user).to be_valid
  end
end