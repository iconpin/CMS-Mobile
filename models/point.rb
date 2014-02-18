module CMS
  module Models
    class Point < Group
      include Core::SortFields

      property :coord_x, Float, :required => true
      property :coord_y, Float, :required => true

      has n, :point_extras
      has n, :extras, :through => :point_extras

      def point_multimedias
        self.group_multimedias
      end

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
