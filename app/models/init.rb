require_relative 'core/base_fields'
require_relative 'core/content_fields'
require_relative 'core/sort_fields'

require_relative 'multimedia'
require_relative 'group'
require_relative 'group_multimedia'
require_relative 'extra'
require_relative 'point'
require_relative 'point_extra'

require_relative 'user'
require_relative 'info'

module CMS
  class App
    DataMapper::setup(:default, "sqlite3://#{App.root}/db/database.db")
    DataMapper.finalize

    Models::Multimedia.auto_upgrade!
    Models::Group.auto_upgrade!
    Models::GroupMultimedia.auto_upgrade!
    Models::Extra.auto_upgrade!
    Models::Point.auto_upgrade!
    Models::PointExtra.auto_upgrade!
    Models::User.auto_upgrade!
    Models::Info.auto_upgrade!
  end
end
