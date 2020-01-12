class TaskListsController < ApplicationController
  def index
    @task_lists = TaskList.all
  end

  def show
  end

  def new
  end

  def edit
  end
end
