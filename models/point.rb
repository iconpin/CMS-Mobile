module CMS
  module Models
    class Point
      include DataMapper::Resource
      include Utils::DateTime

      property :id, Serial
      property :name, String, :length => 255, :required => true, :unique => true
      property :description, Text, :required => false, :lazy => false
      property :coord_x, Float, :required => true
      property :coord_y, Float, :required => true
      property :weight, Integer, :required => true, :default => 0
      property :created_at, DateTime, :required => true
      property :updated_at, DateTime, :required => true
      property :published, Boolean, :required => true, :default => false
      property :deleted_at, ParanoidDateTime

      has n, :point_multimedias
      has n, :multimedias, :through => :point_multimedias

      has n, :point_extras
      has n, :extras, 'Multimedia', :through => :point_extras

      has n, :tips

      def published?
        self.published
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
