class CMS
  module Views
    class PointEdit < Layout
      def point
        @current_point ||= nil
      end
    end
  end
end
