require 'sidekiq'
require 'mini_magick'

class CMS
  module Workers
    class ImageConverter
      include Sidekiq::Worker

      def perform(db_image)
        image = MiniMagick::Image.open(db_image.path_tmp)
        image.resize("200x200")
        image.write(db_image.path)

        db_image.ready = true
        db_image.save
      end
    end
  end
end
