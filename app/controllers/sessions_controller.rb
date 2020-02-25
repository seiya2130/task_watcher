class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in(user)
      flash[:notice] = "ログインしました"
      redirect_to("/users/#{user.id}") 
    else
      flash[:danger] = "メールアドレスまたはパスワードが誤っています"
      render("/sessions/new")
    end
  end

  def destroy
    log_out
    flash[:notice] = "ログアウトしました"
    redirect_to("/")
  end
end
