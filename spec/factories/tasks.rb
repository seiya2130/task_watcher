FactoryBot.define do
    factory :task do
        name { 'test' }
        status { 0 }
        dead_line { Date.today }
        task_list
    end
    factory :task_request, class: Task do
        name { 'test' }
        status { 0 }
        dead_line { Date.today }
    end
    factory :task_request_update, class: Task do
        name { 'test_' }
        status { 0 }
        dead_line { Date.today }
    end
  end