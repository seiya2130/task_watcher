class ApplicationController < ActionController::Base
    helper_method :convert_status, :convert_date

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
