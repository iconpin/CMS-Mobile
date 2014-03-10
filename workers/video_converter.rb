module CMS
  module Workers
    class VideoConverter
      include Sidekiq::Worker
      sidekiq_options :retry => 0

      sidekiq_retries_exhausted do |msg|
        video = CMS::Models::Video.get(@video_id)
        video.error = msg['error_message']
        video.ready = false
        video.save
      end

      def perform(video_id)
        @video_id = video_id
        video = CMS::Models::Video.get(video_id)

        input_path = video.path_tmp.to_s
        output_path = video.path.to_s
        thumbnail_path = video.path_thumbnail.to_s

        movie = FFMPEG::Movie.new(input_path)

        movie.transcode(
          output_path,
          {
            :video_codec => 'libx264',
            :x264_vprofile => 'baseline',
            :audio_codec => 'libvo_aacenc',
            :custom => '-filter:v "scale=iw*min(480/iw\,320/ih):ih*min(480/iw\,320/ih), pad=480:320:(480-iw*min(480/iw\,320/ih))/2:(320-ih*min(480/iw\,320/ih))/2"'
          }
        )

        movie.screenshot(
          video.path_thumbnail.to_s,
          { :resolution => '512x512' },
          :preserve_aspect_ratio => :width
        )

        image = MiniMagick::Image.open thumbnail_path
        result = image.composite(MiniMagick::Image.open(File.join(CMS::App.root, 'workers', 'play.png'))) do |c|
          c.gravity 'center'
        end
        result.write thumbnail_path

        cmd = "convert #{thumbnail_path} -type TrueColorMatte -define png:color-type=6 #{thumbnail_path}"
        Kernel.system(cmd)

        video.ready = true
        video.save
      end
    end
  end
end
