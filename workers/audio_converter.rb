module CMS
  module Workers
    class AudioConverter
      include Sidekiq::Worker
      sidekiq_options :retry => 0

      sidekiq_retries_exhausted do |msg|
        audio = Models::Audio.get(@audio_id)
        audio.error = msg['error_message']
        audio.ready = false
        audio.save
      end

      def perform audio_id
        @audio_id = audio_id
        audio = Models::Audio.get(@audio_id)
        audio.ready = true
        audio.save
        # TODO conversion?
      end
    end
  end
end
