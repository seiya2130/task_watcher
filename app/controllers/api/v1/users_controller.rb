class Api::V1::UsersController < ApplicationController
    before_action :logged_in_user,only:[:show,:update]
    before_action :correct_user,only:[:show,:update]
    before_action :check_guest_user,only:[:update]

    def create
      @user = User.new(user_params)
      if @user.save
        log_in(@user)
        render json: { user: @user, message:'ユーザーを登録しました'}, status: :created
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def show
      @user = User.find(params[:id])
      render json: @user
    end
  
    def update
      @user = User.find(params[:id])
      @user.update(user_params)
      if @user.save
        render json: { user: @user, message:'ユーザー情報を更新しました'} , status: :ok
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def correct_user
      @user = User.find_by(id: params[:id])
      if @user.id != @current_user.id
        render json: { errors: ['権限がありません'] }, status: :unauthorized
      end
    end

    def check_guest_user
      @user = User.find_by(id: params[:id])
      if(@user.email == 'guestuser@guestuser.com')
        render json: { errors: ["ゲストユーザーの情報は編集できません"] }, status: :unauthorized
      end
    end

  
    private
      def user_params
        params.fetch(:user, {}).permit(:name, :email, :password)
      end

  end
  