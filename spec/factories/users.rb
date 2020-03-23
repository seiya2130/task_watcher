FactoryBot.define do
    factory :user do
      name { 'test' }
      email { 'test@test.com' }
      password { 'password' }
    end
    factory :user2, class: User do
      name { 'test2' }
      email { 'test2@test2.com' }
      password { 'password2' }
    end
    factory :guest, class: User do
      name { 'ゲスト' }
      email { 'guest@guest.com' }
      password { 'cde34rfv' }
    end
  end