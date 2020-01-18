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
  end

  private

  def task_params
    params.require(:task).permit(:name, :status, :dead_line, :task_list_id)
  end

end
