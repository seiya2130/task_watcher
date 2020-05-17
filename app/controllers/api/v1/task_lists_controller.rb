class Api::V1::TaskListsController < ApplicationController
    before_action :logged_in_user
    before_action :correct_user,only:[:show,:update,:destroy]

    def index
      @task_lists = TaskList.where(user_id: @current_user)
      render json: @task_lists
    end
      
    def new
      head :ok
    end
  
    def show
      @task_list = TaskList.find_by(id: params[:id])
      @tasks = @task_list.tasks
      render json: { taskList: @task_list, tasks: @tasks }
    end

    def create
      @task_list = @current_user.task_lists.build(task_list_params)
      if @task_list.save
        render json: { message: 'タスクリストを作成しました'}
      else
        render json: { errors: @task_list.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def update
      @task_list = TaskList.find_by(id: params[:id])
      @task_list.update(task_list_params)
      if @task_list.save
        render json: { message: 'タスクリストを更新しました'}
      else
        render json: { errors: @task_list.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def destroy
      @task_list = TaskList.find_by(id: params[:id])
      @task_list.destroy
      @task_lists = TaskList.where(user_id: @current_user)
      render json: { task_lists: @task_lists ,message: 'タスクリストを削除しました'}
    end
  
    def correct_user
      @task_list = TaskList.find_by(id: params[:id])
      if @task_list.user_id != @current_user.id
        render json: { errors: ["権限がありません"] }, status: :unauthorized
      end
    end
  
    private
  
    def task_list_params
      params.fetch(:task_list, {}).permit(:name)
    end
  
  end
  