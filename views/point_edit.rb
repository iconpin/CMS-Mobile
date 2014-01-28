class CMS
  module Views
    class PointEdit < Layout
      def point
        @current_point ||= nil
      end

      def multimedia
        list = []
        CMS::Models::Multimedia.all.each do |m| #:point.not => @current_point).each do |m|
          list << {
            :name => m.name,
            :id => m.id,
            :linked => (m.point == @current_point),
            :link => "/multimedia/#{m.id}"
          }
        end
      end
    end
  end
end
