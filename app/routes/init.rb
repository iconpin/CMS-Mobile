require_relative 'base'
require_relative 'user'
require_relative 'multimedia'
require_relative 'point'
require_relative 'extra'
require_relative 'info'
require_relative 'status'
require_relative 'api'

module CMS
  class App
    use Routes::Base
    use Routes::User
    use Routes::Multimedia
    use Routes::Point
    use Routes::Extra
    use Routes::Info
    use Routes::Status
    use Routes::API
  end
end
