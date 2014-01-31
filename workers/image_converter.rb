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
        image = CMS::Models::Image.get(image_id)
        i = MiniMagick::Image.open(image.path_tmp.to_s)
        i.resize('400x400')
        i.write(image.path.to_s)

        image.ready = true
        image.save
      end
    end
  end
end
