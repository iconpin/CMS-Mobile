require 'sidekiq'
require 'streamio-ffmpeg'

module CMS
  module Workers
    class VideoConverter
      include Sidekiq::Worker
      sidekiq_options :retry => 3

      sidekiq_retries_exhausted do |msg|
        video_db = CMS::Models::Video.get(@video_id)
        video_db.ready = false
        video_db.error = mgs['error_message']
      end

      def perform(video_id)
        @video_id = video_id
        video = CMS::Models::Video.get(video_id)
        movie = FFMPEG::Movie.new(video.path_tmp.to_s)
        movie.transcode(video.path)
        movie.screenshot(
          video.path_thumbnail.to_s,
          { :resolution => '400x400' },
          :preserve_aspect_ratio => :width
        )

        video.ready = true
        video.save
      end
    end
  end
end
