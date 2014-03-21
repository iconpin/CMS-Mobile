module CMS
  module Controllers
    class Multimedia
      @extensions = []
      @type = Models::Multimedia

      def self.upload params
        file = params['file'][:tempfile]
        filename = params['file'][:filename]
        extension = File.extname(filename).downcase

        unless @extensions.include?(extension)
          puts @extensions
          puts extension
          return nil
        end

        name = params['name']
        description = params['description']
        tip = params['tip']

        multimedia = Models::Multimedia.create(
          :name => name,
          :description => description,
          :tip => tip,
          :type => @type,
          :created_at => Time.now
        )

        return nil unless multimedia.saved?

        multimedia.path_tmp = File.join(TMP_DIR, "#{multimedia.id}#{extension}")

        File.open(multimedia.path_tmp, 'wb') do |f|
          f.write(file.read)
        end

        if multimedia.save
          multimedia
        else
          nil
        end
      end

      def self.publish params
        m = Models::Multimedia.get(params['id'])
        return false if m.nil?
        m.published = true
        return m.save
      end

      def self.unpublish params
        m = Models::Multimedia.get(params['id'])
        return false if m.nil?
        m.published = false
        return m.save
      end

      def self.destroy params
        id = params['id']
        multimedia = Models::Multimedia.get(id)
        return false if multimedia.nil?

        [multimedia.path, multimedia.path_tmp, multimedia.path_thumbnail].each do |path|
          begin
            File.delete(path) if File.exist?(path.to_s)
          rescue Errno::ENOENT
            # XXX: we ignore an error
          end
        end

        return multimedia.destroy
      end

      def self.edit params
        multimedia = Models::Multimedia.get(params['id'])
        return false if multimedia.nil?

        name = params['name']
        description = params['description']
        tip = params['tip']
        published = (params['published'] == 'on')

        multimedia.name = name
        multimedia.description = description
        multimedia.tip = tip
        multimedia.published = published

        return multimedia.save
      end
    end

    class Image < Multimedia
      @extensions = ['.jpg', '.jpeg', '.png']
      @type = Models::Image

      def self.upload params
        image = super(params)
        return nil if image.nil?

        image.path = File.join(CMS::MULTIMEDIA_DIR, File.basename(image.path_tmp))
        image.path_thumbnail = File.join(CMS::THUMBNAIL_DIR, File.basename(image.path_tmp))

        if image.save
          Workers::ImageConverter.perform_async(image.id)
          true
        else
          false
        end
      end
    end

    class Video < Multimedia
      @extensions = ['.mp4', '.mov', '.avi']
      @type = Models::Video

      def self.upload params
        video = super(params)
        return nil if video.nil?

        video.path = File.join(CMS::MULTIMEDIA_DIR, "#{video.id}.ts")
        video.path_thumbnail = File.join(CMS::THUMBNAIL_DIR, "#{File.basename(video.path)}.png")

        if video.save
          Workers::VideoConverter.perform_async(video.id)
          true
        else
          false
        end
      end
    end

    class Audio < Multimedia
      @extensions = ['.wav', '.mp3', '.ogg', '.aif']
      @type = Models::Audio

      def self.upload params
        audio = super(params)
        return nil if audio.nil?

        audio.path = File.join(CMS::MULTIMEDIA_DIR, "#{audio.id}.mp3")

        if audio.save
          Workers::AudioConverter.perform_async(audio.id)
          true
        else
          false
        end
      end
    end
  end
end
