module CMS
  module Models
    class Point < Group
      property :coord_x, Float, :required => true
      property :coord_y, Float, :required => true
      property :weight, Integer, :required => true, :default => 0

      has n, :point_extras
      has n, :extras, :through => :point_extras

      def link
        "/point?id=#{self.id}"
      end

      def edit_link
        "/point/edit?id=#{self.id}"
      end

      def multimedia_link
        "/point/multimedia?id=#{self.id}"
      end

      def extra_link
        "/point/extra?id=#{self.id}"
      end
    end
  end
end
