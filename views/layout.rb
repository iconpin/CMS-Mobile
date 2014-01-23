class CMS
  module Views
    class Layout < Mustache
      def title
        @title || "Cheese Mouse System"
      end

      def user
        @current_user
      end
    end
  end
end
