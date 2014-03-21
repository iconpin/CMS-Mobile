require 'sinatra/base'
require 'rack/flash'
require 'data_mapper'
require 'warden'
require 'haml'

require 'sidekiq'
require 'streamio-ffmpeg'
require 'mini_magick'

module CMS
  class App < Sinatra::Base
    set :root, File.join(File.dirname(__FILE__), '..')
    set :views, 'app/views'

    require_relative 'config/init'
    require_relative 'utils/init'
    require_relative 'models/init'
    require_relative 'controllers/init'
    require_relative 'workers/init'
    require_relative 'routes/init'
  end
end
