module CMS
  module Models
    class Multimedia
      include DataMapper::Resource
      include Utils::DateTime

      property :id, Serial
      property :name, String, :required => true
      property :path_tmp, FilePath
      property :path, FilePath
      property :path_thumbnail, FilePath
      property :ready, Boolean, :required => true, :default => false
      property :error, Text
      property :description, Text, :required => false
      property :published, Boolean, :required => true, :default => false
      property :created_at, DateTime, :required => true
      property :updated_at, DateTime, :required => true

      property :type, Discriminator  # Allows Single Table Inheritance

      belongs_to :point, :required => false

      has n, :tips

      def published?
        self.published
      end

      def image?
        false
      end

      def video?
        false
      end

      def link
        "/multimedia?id=#{self.id}"
      end

      def edit_link
        "/multimedia/edit?id=#{self.id}"
      end

      def static_link
        "/static/multimedia/#{File.basename(self.path)}"
      end

      def thumbnail_link
        "/static/thumbnail/#{File.basename(self.path_thumbnail)}"
      end
    end

    class Image < Multimedia
      def image?
        true
      end
    end

    class Video < Multimedia
      def video?
        true
      end
    end
  end
end
