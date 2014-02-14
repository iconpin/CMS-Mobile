module CMS
  module Controllers
    class Multimedia
      def self.upload_image params
        file = params['file'][:tempfile]
        filename = params['file'][:filename]
        extension = File.extname(filename)
        unless ['.jpg', '.jpeg', '.png'].include?(extension.downcase)
          return false
        end
        name = params['name']
        description = params['description']
        tip = params['tip']

        image = Models::Image.new(
          :name => name,
          :description => description,
          :tip => tip,
          :created_at => Time.now,
          :updated_at => Time.now
        )
        unless image.save  # Now we'll have and ID
          return false
        end

        image.path_tmp = File.join(TMP_DIR, "#{image.id}#{extension}")
        File.open(image.path_tmp, 'wb') do |f|
          f.write file.read
        end

        # If we're here, the upload was successful
        image.path = File.join(MULTIMEDIA_DIR, "/#{image.id}#{extension}")
        image.path_thumbnail = File.join(THUMBNAIL_DIR, "/#{image.id}#{extension}")
        if image.save
          Workers::ImageConverter.perform_async(image.id)  # First Sidekiq usage here!
          return true
        else
          return false
        end
      end

      def self.upload_video params
        file = params['file'][:tempfile]
        filename = params['file'][:filename]
        extension = File.extname(filename)
        name = params['name']
        description = params['description']
        tip = params['tip']

        video = Models::Video.new(
          :name => name,
          :description => description,
          :tip => tip,
          :created_at => Time.now,
          :updated_at => Time.now
        )
        unless video.save  # Now we'll have and ID
          return false
        end

        video.path_tmp = File.join(TMP_DIR, "#{video.id}#{extension}")
        File.open(video.path_tmp, 'wb') do |f|
          f.write file.read
        end

        # If we're here, the upload was successful
        video.path = File.join(MULTIMEDIA_DIR, "/#{video.id}.ts")
        video.path_thumbnail = File.join(THUMBNAIL_DIR, "/#{video.id}.jpg")
        if video.save
          Workers::VideoConverter.perform_async(video.id)  # First Sidekiq usage here!
          return true
        else
          return false
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
        if multimedia.nil?
          false
        end

        begin
          File.delete(multimedia.path_tmp) if File.exist?(multimedia.path_tmp)
        rescue Errno::ENOENT
          return false
        end

        begin
          File.delete(multimedia.path) if !File.exist?(multimedia.path)
        rescue Errno::ENOENT
          return false
        end

        begin
          File.delete(multimedia.path_thumbnail) if !File.exist?(multimedia.path_thumbnail)
        rescue Errno::ENOENT
          return false
        end

        return multimedia.destroy
      end

      def self.edit params
        multimedia = Models::Multimedia.get(params['id'])
        if multimedia.nil?
          return false
        end

        name = params['name']
        description = params['description']
        published = (params['published'] == 'on')

        multimedia.name = name
        multimedia.description = description
        multimedia.published = published

        return multimedia.save
      end
    end
  end
end
