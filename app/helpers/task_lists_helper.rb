module TaskListsHelper

    def exist_task_list?
        @task_list.present?
    end

    def exist_task?
        @tasks.present?
    end

end
