module CMS
  module Models
    class Point < Group
      include Core::SortFields

      property :coord_x, Float
      property :coord_y, Float

      has n, :point_extras, :order => [:weight.asc]
      has n, :extras, :through => :point_extras

      before :destroy do |point|
        point.point_extras.each do |pe|
          pe.destroy
        end
      end

      def point_multimedias
        group_multimedias
      end

      def extras_sorted
        extras = []
        point_extras(:order => [:weight.asc]).each do |pe|
          extras << pe.extra
        end
        extras
      end

      def extras_sorted_published
        extras_sorted.select {|e| e.published && !e.deleted?}
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
