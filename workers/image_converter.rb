require 'sidekiq'
require 'mini_magick'

class CMS
  module Workers
    class ImageConverter
      include Sidekiq::Worker
      sidekiq_options :retry => 3

      sidekiq_retries_exhausted do |msg|
        image_db = CMS::Models::Image.get(@image_id)
        image_db.ready = false
        image_db.error = msg['error_message']
      end

      def perform(image_id)
        @image_id = image_id
        image_db = CMS::Models::Image.get(image_id)
        puts image_db.path_tmp
        puts image_db.path
        image = MiniMagick::Image.open(image_db.path_tmp)
        image.resize("200x200")
        image.format("jpg")
        image.write(image_db.path)

        image_db.ready = true
        image_db.save
      end
    end
  end
end
