class TasksController < ApplicationController
  def new
    @task_list = TaskList.find_by(id: params[:id])
    @task = @task_list.tasks.build
  end

  def create
    @task_list = TaskList.find_by(id: params[:id])
    @task = @task_list.tasks.build(task_params)
    @task.save
    redirect_to("/task_lists/show/#{@task_list.id}")
  end

  def edit
    @task = Task.find_by(id: params[:id])
  end

  def update
    @task = Task.find_by(id: params[:id])
    @task.update(task_params)
    @task.save
    redirect_to("/tasks/#{@task.id}")
  end

  def destroy
    @task = Task.find_by(id: params[:id])
    @task_list = TaskList.find_by(id: @task.task_list)
    @task.destroy
    redirect_to("/task_lists/show/#{@task_list.id}")
  end

  private

  def task_params
    params.require(:task).permit(:name, :status, :dead_line, :task_list_id)
  end

end
