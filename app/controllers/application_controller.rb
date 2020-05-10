class ApplicationController < ActionController::Base
    include SessionsHelper
    before_action :current_user
    helper_method :convert_status, :convert_date

    def logged_in_user
      unless logged_in?
        render json: { errors: ["ログインが必要です"] }, status: :unauthorized
      end 
    end
end
