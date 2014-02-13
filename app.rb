require 'sinatra/base'
require 'rack/flash'
require 'data_mapper'
require 'warden'
require 'haml'


module CMS
  # Storage config
  MULTIMEDIA_DIR = "#{Dir.pwd}/storage/multimedia"
  TMP_DIR = "#{Dir.pwd}/storage/tmp"
  THUMBNAIL_DIR = "#{Dir.pwd}/storage/thumbnail"

  class App < Sinatra::Base

    # Utils
    require_relative 'utils/date_time'
    require_relative 'utils/coordinates'

    # DataMapper configuration
    require_relative 'models/user'
    require_relative 'models/point'
    require_relative 'models/multimedia'
    require_relative 'models/point_multimedia'
    require_relative 'models/point_extra'
    require_relative 'models/tip'

    DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/database.db")
    DataMapper.finalize

    Models::User.auto_upgrade!
    Models::Point.auto_upgrade!
    Models::Multimedia.auto_upgrade!
    Models::PointMultimedia.auto_upgrade!
    Models::PointExtra.auto_upgrade!

    # Controllers
    require_relative 'controllers/user'
    require_relative 'controllers/point'
    require_relative 'controllers/multimedia'

    set :views, 'views'

    # Require workers
    require_relative 'workers/image_converter'
    require_relative 'workers/video_converter'

    # Routes
    require_relative 'routes/base'
    require_relative 'routes/user'
    require_relative 'routes/multimedia'
    require_relative 'routes/point'
    require_relative 'routes/api'

    use Routes::Base
    use Routes::User
    use Routes::Multimedia
    use Routes::Point
    use Routes::API
  end
end
