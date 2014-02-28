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
        movie = FFMPEG::Movie.new(video.path_tmp.to_s)
        movie.transcode(
          video.path.to_s,
          {
            :video_codec => 'libx264',
            :x264_vprofile => 'baseline',
            :audio_codec => 'libvo_aacenc'
          }
        )
        movie.screenshot(
          video.path_thumbnail.to_s,
          { :resolution => '512x512' },
          :preserve_aspect_ratio => :width
        )

        video.ready = true
        video.save
      end
    end
  end
end
