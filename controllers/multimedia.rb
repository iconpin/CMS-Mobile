class CMS
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

        image = Models::Image.new(
          :name => name,
          :description => description,
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

        video = Models::Video.new(
          :name => name,
          :description => description,
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
        if video.save
          Workers::VideoConverter.perform_async(video.id)  # First Sidekiq usage here!
          return true
        else
          return false
        end
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

        return multimedia.destroy
      end
    end
  end
end
