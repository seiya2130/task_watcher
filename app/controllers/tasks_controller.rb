class TasksController < ApplicationController
  before_action :logged_in_user
  before_action :correct_user,only:[:edit,:update,:destroy]

  def new
    @task_list = TaskList.find_by(id: params[:task_list_id])
    @task = @task_list.tasks.build(task_list_id: @task_list)
  end

  def create
    @task_list = TaskList.find_by(id: params[:task_list_id])
    @task = @task_list.tasks.build(task_params)
    if @task.save
      flash[:notice] = "タスクを作成しました"
      redirect_to controller: 'task_lists', action: 'show', id: @task_list
    else
      render 'new'
    end
  end

  def edit
    @task = Task.find_by(id: params[:id])
  end

  def update
    @task = Task.find_by(id: params[:id])
    @task.update(task_params)
    if @task.save
      flash[:notice] = "タスクを更新しました"
      redirect_to controller: 'task_lists', action: 'show', id: @task.task_list_id
    else
      render 'edit'
    end
  end

  def destroy
    @task = Task.find_by(id: params[:id])
    @task.destroy
    flash[:notice] = "タスクを削除しました"
    redirect_to controller: 'task_lists', action: 'show', id: @task.task_list_id
  end

  def progress
    @task_lists = TaskList.where(user_id: @current_user.id)
    @progress_tasks = []

    @task_lists.each do |task_list|
      @task = Task.where(status: 1, task_list_id: task_list)
      @task.each do |task| 
        @progress_tasks.push(task)
      end
    end
    
  end

  def correct_user
    @task = Task.find_by(id: params[:id])
    @task_list = TaskList.find_by(id: @task.task_list_id)
    if @task_list.user_id != @current_user.id
      flash[:danger] = "権限がありません"
      redirect_to controller: 'task_lists', action: 'index'
    end
  end
  
  private

  def task_params
    params.require(:task).permit(:name, :status, :dead_line, :task_list_id)
  end

end
