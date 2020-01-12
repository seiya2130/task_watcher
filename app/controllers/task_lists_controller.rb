class TaskListsController < ApplicationController
  def index
    @task_lists = TaskList.all
  end

  def show
    @task_list = TaskList.find_by(id: params[:id])
  end

  def new
  end

  def create
    @task_list = TaskList.new(name: params[:name])
    @task_list.save
    redirect_to("/task_lists/index")
  end

  def edit  
    @task_list = TaskList.find_by(id: params[:id])
  end

  def update
    @task_list = TaskList.find_by(id: params[:id])
    @task_list.name = params[:name]
    @task_list.save
    redirect_to("/task_lists/index")
  end
end
