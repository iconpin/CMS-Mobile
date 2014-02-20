module CMS
  module Workers
    class ImageConverter
      include Sidekiq::Worker
      sidekiq_options :retry => 0

      sidekiq_retries_exhausted do |msg|
        image = CMS::Models::Image.get(@image_id)
        image.error = msg['error_message']
        image.ready = false
        image.save
      end

      def perform(image_id)
        @image_id = image_id
        image = CMS::Models::Image.get(image_id)

        i = MiniMagick::Image.open(image.path_tmp.to_s)
        i.resize('1024x1024')
        i.write(image.path.to_s)

        j = MiniMagick::Image.open(image.path_tmp.to_s)
        j.resize('400x400')
        j.write(image.path_thumbnail.to_s)

        image.ready = true
        image.save
      end
    end
  end
end
