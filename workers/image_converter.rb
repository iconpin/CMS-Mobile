require 'sidekiq'
require 'mini_magick'

class CMS
  module Workers
    class ImageConverter
      include Sidekiq::Worker

      def perform(image_id)
        image_db = CMS::Models::Image.get(image_id)
        image = MiniMagick::Image.open(image_db.path_tmp)
        image.resize("200x200")
        image.write(image_db.path)

        image_db.ready = true
        image_db.save
      end
    end
  end
end
