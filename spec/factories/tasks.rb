FactoryBot.define do
    factory :task do
        name { 'test' }
        status { '未着手' }
        dead_line { Date.today }
        task_list
    end
  end