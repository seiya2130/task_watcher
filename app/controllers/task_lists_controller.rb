class TaskListsController < ApplicationController
  helper_method :convert_status, :convert_date

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
    @task_list.name = params[:name]
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

  def convert_status(status)
    if status == "0"
      return "未着手"
    elsif status == "1"
      return "進行中"
    elsif status == "2"
      return "完了"
    end

  end

  def convert_date(date)
    return date.strftime("%Y年%m月%d日")
  end

end
