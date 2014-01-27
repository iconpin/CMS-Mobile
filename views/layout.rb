class CMS
  module Views
    class Layout < Mustache
      def title
        @title || "Cheese Mouse System"
      end

      def user
        @current_user
      end

      def admin
        @current_user.admin?
      end

      def guest
        @current_user.guest?
      end

      def flash
        @flash
      end
    end
  end
end
