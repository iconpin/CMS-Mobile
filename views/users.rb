class CMS
  module Views
    class Users < Layout
      def list_user
        list_user = []
        CMS::Models::User.all.each do |u|
          list_user << u
        end
      end
    end
  end
end
