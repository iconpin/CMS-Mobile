require 'sinatra/base'
require 'rack/flash'
require 'data_mapper'
require 'warden'
require 'haml'

require 'sidekiq'
require 'streamio-ffmpeg'
require 'mini_magick'

module CMS
  # Storage config
  MULTIMEDIA_DIR = "#{Dir.pwd}/storage/multimedia"
  TMP_DIR = "#{Dir.pwd}/storage/tmp"
  THUMBNAIL_DIR = "#{Dir.pwd}/storage/thumbnail"

  class App < Sinatra::Base
    # Sinatra options
    set :views, 'views'
    set :root, File.dirname(__FILE__)

    # Utils
    require_relative 'utils/date_time'
    require_relative 'utils/coordinates'

    # DataMapper configuration
    require_relative 'models/core/base_fields'
    require_relative 'models/core/content_fields'
    require_relative 'models/core/sort_fields'

    require_relative 'models/multimedia'
    require_relative 'models/group'
    require_relative 'models/group_multimedia'
    require_relative 'models/extra'
    require_relative 'models/point'
    require_relative 'models/point_extra'

    require_relative 'models/user'

    DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/database.db")
    DataMapper.finalize

    Models::Multimedia.auto_upgrade!
    Models::Group.auto_upgrade!
    Models::GroupMultimedia.auto_upgrade!
    Models::Extra.auto_upgrade!
    Models::Point.auto_upgrade!
    Models::PointExtra.auto_upgrade!
    Models::User.auto_upgrade!

    # Controllers
    require_relative 'controllers/user'
    require_relative 'controllers/point'
    require_relative 'controllers/multimedia'

    # Workers
    require_relative 'workers/image_converter'
    require_relative 'workers/video_converter'

    # Routes
    require_relative 'routes/base'
    require_relative 'routes/user'
    require_relative 'routes/multimedia'
    require_relative 'routes/point'
    require_relative 'routes/extra'
    require_relative 'routes/status'
    require_relative 'routes/api'

    use Routes::Base
    use Routes::User
    use Routes::Multimedia
    use Routes::Point
    use Routes::Extra
    use Routes::Status
    use Routes::API
  end
end
