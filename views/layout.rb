class CMS
  module Views
    class Layout < Mustache
      def title
        @title || "Cheese Mouse System"
      end

      def user
        @current_user
      end

      def error
        if @flash
          @flash[:error]
        end
      end

      def success
        if @flash
          @flash[:success]
        end
      end

      def alert
        if @flash.nil?
          false
        else
          true
        end
      end
    end
  end
end
