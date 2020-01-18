class TaskListsController < ApplicationController
  def index
    @task_lists = TaskList.all
  end

  def show
    @task_list = TaskList.find_by(id: params[:id])
    @tasks = @task_list.tasks
  end

  def new
    @task_list = TaskList.new
  end

  def create
    @task_list = TaskList.new(name: params[:name])
    if @task_list.save
      flash[:notice] = "タスクリストを追加しました" 
      redirect_to("/task_lists/index")
    else
      render("/task_lists/new")
    end
  end

  def edit  
    @task_list = TaskList.find_by(id: params[:id])
  end

  def update
    @task_list = TaskList.find_by(id: params[:id])
    @task_list.name = params[:name]
    if @task_list.save
      flash[:notice] = "タスクリストを更新しました"
      redirect_to("/task_lists/index")
    else
      render("/task_lists/edit")
    end
  end

  def destroy
    @task_list = TaskList.find_by(id: params[:id])
    @task_list.destroy
    flash[:notice] = "タスクリストを削除しました"
    redirect_to("/task_lists/index")
  end

end
