class CMS
  module Views
    class Users < Layout
      def user
        CMS::Models::User.all
      end
    end
  end
end
