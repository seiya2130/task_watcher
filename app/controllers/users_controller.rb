class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = "ユーザーを登録しました"
      redirect_to("/users/#{@user.id}") 
    else
      render('/users/new')
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    if @user.save
      flash[:notice] = "ユーザー情報を更新しました"
      redirect_to("/users/#{@user.id}") 
    else
      render("/users/edit")
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end

end
