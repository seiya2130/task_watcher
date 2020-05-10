class Api::V1::TasksController < ApplicationController
    before_action :logged_in_user
    before_action :correct_user,only:[:edit,:update,:destroy]
  
    def new
      head :ok
    end

    def create
      @task_list = TaskList.find_by(id: params[:task_list_id])
      @task = @task_list.tasks.build(task_params)
      if @task.save
        render json: { message: 'タスクを作成しました'}
      else
        render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def edit
      @task = Task.find_by(id: params[:id])
      render json: @task
    end
  
    def update
      @task = Task.find_by(id: params[:id])
      @task.update(task_params)
      if @task.save
        render json: { message: 'タスクを更新しました'}
      else
        render json: { errors: @task.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def destroy
      @task = Task.find_by(id: params[:id])
      @task_list_id = @task.task_list_id
      @task.destroy
      @tasks = Task.where(task_list_id: @task_list_id)
      render json: { tasks: @tasks, message: 'タスクを削除しました'}
    end
  
    def progress
      @task_lists = TaskList.where(user_id: @current_user.id)
      @progress_tasks = []
      @progress_task_lists = []
  
      @task_lists.each do |task_list|
        @task = Task.where(status: 1, task_list_id: task_list)
        @task.each do |task|
          @progress_task_lists.push(task_list)
          @progress_tasks.push(task)
        end
      end
      render json:{ task_lists: @progress_task_lists, tasks: @progress_tasks }
    end
  
    def correct_user
      @task = Task.find_by(id: params[:id])
      @task_list = TaskList.find_by(id: @task.task_list_id)
      if @task_list.user_id != @current_user.id
        render json: { errors: ["権限がありません"] }, status: :unauthorized
      end
    end
    
    private
  
    def task_params
      params.fetch(:task, {}).permit(:name, :status, :dead_line, :task_list_id)
    end
  
  end
  