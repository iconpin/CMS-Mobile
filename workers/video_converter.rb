require 'sidekiq'
require 'streamio-ffmpeg'

class CMS
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
        movie = FFMPEG::Movie.new(video.path_tmp)
        movie.transcode(video.path)
        video.ready = true
        video.save
      end
    end
  end
end
