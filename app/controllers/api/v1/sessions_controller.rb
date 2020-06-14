class Api::V1::SessionsController < ApplicationController

    def create
        @user = User.find_by(email: params[:session][:email].downcase)
        if @user && @user.authenticate(params[:session][:password])
          log_in(@user)
          render json: { user: @user, message:'ログインしました'}, status: :created
        else
            render json: { errors: ["メールアドレスまたはパスワードが誤っています"] }, status: :bad_request
        end
      end
    
      def destroy
        log_out
        render json: { message: 'ログアウトしました'}
      end

  end
  