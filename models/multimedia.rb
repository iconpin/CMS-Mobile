require 'data_mapper'

class CMS
  module Models
    class Multimedia
      include DataMapper::Resource
      property :id, Serial
      property :name, String, :required => true
      property :path_tmp, FilePath
      property :path, FilePath
      property :ready, Boolean, :required => true, :default => false
      property :error, Text
      property :description, Text, :required => false
      property :weight, Integer, :required => true, :default => 0
      property :published, Boolean, :required => true, :default => false
      property :created_at, DateTime, :required => true
      property :updated_at, DateTime, :required => true

      property :type, Discriminator  # Allows Single Table Inheritance

      belongs_to :point, :required => false

      def image?
        false
      end

      def video?
        false
      end

      def link
        "/multimedia?id=#{self.id}"
      end

      def static_link
        "/static/#{File.basename(self.path)}"
      end
    end

    class Image < Multimedia
      def image?
        true
      end

      def link
        "/image?id=#{self.id}"
      end
    end
    class Video < Multimedia
      def video?
        true
      end

      def link
        "/video?id=#{self.id}"
      end
    end
  end
end
