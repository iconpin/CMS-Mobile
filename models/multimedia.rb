module CMS
  module Models
    class Multimedia
      include Core::ContentFields

      property :path_tmp, FilePath
      property :path, FilePath
      property :path_thumbnail, FilePath
      property :ready, Boolean, :required => true, :default => false
      property :error, Text

      property :type, Discriminator  # Allows Single Table Inheritance

      belongs_to :group, :required => false

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

      def groups
        GroupMultimedia.all(:multimedia => self).group
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
