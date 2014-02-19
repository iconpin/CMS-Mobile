module CMS
  module Models
    class Multimedia
      include DataMapper::Resource
      include Core::BaseFields
      include Core::ContentFields
      include Utils::DateTime

      property :path_tmp, FilePath
      property :path, FilePath
      property :path_thumbnail, FilePath
      property :ready, Boolean, :required => true, :default => false
      property :error, Text

      property :type, Discriminator  # Allows Single Table Inheritance

      belongs_to :group, :required => false

      def points
        Models::Point.all.select do |p|
          p.multimedias.include?(self)
        end
      end

      def extras
        Models::Extra.all.select do |e|
          e.multimedias.include?(self)
        end
      end

      def groups
        self.points + self.extras
      end

      def image?
        false
      end

      def video?
        false
      end

      def audio?
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

    class Audio < Multimedia
      def audio?
        true
      end
    end
  end
end
