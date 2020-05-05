class ApplicationController < ActionController::Base
    include SessionsHelper
    before_action :current_user
    helper_method :convert_status, :convert_date

    def logged_in_user
      unless logged_in?
        flash[:danger] = "ログインが必要です"
        redirect_to login_url
      end
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
      return date.strftime("%Y/%m/%d")
    end
    
    
end
