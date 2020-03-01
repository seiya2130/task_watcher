class TaskListsController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user,only:[:edit,:update,:destroy]

  def index
    @task_lists = TaskList.where(user_id: @current_user)
  end

  def show
    @task_list = TaskList.find_by(id: params[:id])
    @tasks = @task_list.tasks
  end

  def new
    @task_list = TaskList.new
  end

  def create
    @task_list = @current_user.task_lists.build(name: params[:name])
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

  def correct_user
    @task_list = TaskList.find_by(id: params[:id])
    if @task_list.user_id != @current_user.id
      flash[:danger] = "権限がありません"
      redirect_to("/task_lists/index")
    end
  end

end
