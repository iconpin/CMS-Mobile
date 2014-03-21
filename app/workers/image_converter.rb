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

      MAX_ASPECT_RATIO = (685.0) / (400.0)
      MAX_SIZE = "512x#{(512.0 / MAX_ASPECT_RATIO).to_i}"

      def perform(image_id)
        @image_id = image_id
        image = CMS::Models::Image.get(image_id)

        input_path = image.path_tmp.to_s
        output_path = image.path.to_s
        thumbnail_path = image.path_thumbnail.to_s

        i = MiniMagick::Image.open input_path
        i.resize '512x512'

        aspect_ratio = i[:width].to_f/i[:height].to_f
        if aspect_ratio > MAX_ASPECT_RATIO
          i.combine_options do |c|
            c.background 'black'
            c.gravity 'center'
            c.extent MAX_SIZE
          end
        end

        i.combine_options do |c|
          c.colorspace 'rgb'
          c.type 'truecolor'
        end

        i.write output_path

        i.resize '256x256'
        i.write thumbnail_path

        image.ready = true
        image.save
      end
    end
  end
end
