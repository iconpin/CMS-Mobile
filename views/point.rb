class CMS
  module Views
    class Point < Layout
      def point
        @current_point ||= nil
      end
    end
  end
end
