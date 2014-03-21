module CMS
  module Routes
    class Status < Base
      before do
        admin!
        @path = :status
      end

      get '/status' do
        @stats = Sidekiq::Stats.new
        haml :status
      end
    end
  end
end
