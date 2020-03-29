FactoryBot.define do
    factory :task_list do
      name { 'test' }
      user
    end
    factory :task_list_request, class: TaskList do
      name { 'test' }
    end
    factory :task_list_request_update, class: TaskList do
      name { 'test_' }
    end
  end