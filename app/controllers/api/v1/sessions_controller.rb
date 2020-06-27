class Api::V1::SessionsController < ApplicationController

    def create
        # 未登録だった場合の処理
        # if( params[:session][:email].downcase == 'guest_user@guest_user.com' )
        #   gest_user = User.find_by(email: params[:session][:email].downcase)
        #   if ( gest_user == nil)
        #       log_in(@user)
        #   end
        # end

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
  