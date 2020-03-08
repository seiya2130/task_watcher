class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      log_in(@user)
      flash[:notice] = "ログインしました"
      redirect_to controller: 'users', action: 'show', id: @user
    else
      flash[:danger] = "メールアドレスまたはパスワードが誤っています"
      render 'new'
    end
  end

  def destroy
    log_out
    flash[:notice] = "ログアウトしました"
    redirect_to("/")
  end

  def guest
    user = User.find_by(email: "guest@guest.com")
    if user == nil
      user = User.new(name:"ゲスト",email:"guest@guest.com",password:"cde34rfv")
      user.save
    end
    log_in(user)
    flash[:notice] = "ゲストユーザーでログインしました"
    redirect_to("/users/#{user.id}") 
  end

end
