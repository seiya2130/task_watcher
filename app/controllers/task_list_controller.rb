class TaskListController < ApplicationController
  def index
    @task_lists = TaskList.all
  end

  def new
  end

  def show
  end

  def edit
  end
end
