class Api::V1::UsersController < ApplicationController

    def create
      @user = User.new(user_params)
      if @user.save
        # log_in(@user)
        render json: @user, status: :created
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
        render json: @user, status: :moved_permanently
      else
        render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    private
      def user_params
        params.fetch(:user, {}).permit(:name, :email, :password)
      end

  end
  