class TaskListsController < ApplicationController
  def index
    @task_lists = TaskList.all
  end

  def show
    @task_list = TaskList.find_by(id: params[:id])
  end

  def new
  end

  def edit
  end
end
