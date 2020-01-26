class TasksController < ApplicationController
  def new
    @task_list = TaskList.find_by(id: params[:id])
    @task = @task_list.tasks.build
  end

  def create
    @task_list = TaskList.find_by(id: params[:id])
    @task = @task_list.tasks.build(task_params)
    if @task.save
      flash[:notice] = "タスクを作成しました"
      redirect_to("/task_lists/show/#{@task_list.id}")
    else
      render("/tasks/new")
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
      redirect_to("/task_lists/show/#{@task.task_list_id}")
    else
      render("/tasks/edit")
    end
  end

  def destroy
    @task = Task.find_by(id: params[:id])
    @task_list = TaskList.find_by(id: @task.task_list)
    @task.destroy
    flash[:notice] = "タスクを削除しました"
    redirect_to("/task_lists/show/#{@task_list.id}")
  end

  def progress
    @tasks = Task.where(status: 1)
    @all_task_lists = TaskList.all
    @task_lists = []

    @all_task_lists.each do |task_list|
      @tasks.each do |task|
        if task_list.id == task.task_list_id
          @task_lists.push(task_list)
        end
      end
    end

    @task_lists.uniq!
    
  end


  private

  def task_params
    params.require(:task).permit(:name, :status, :dead_line, :task_list_id)
  end

end
