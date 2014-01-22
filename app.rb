require 'sinatra/base'
require 'mustache/sinatra'

class CMS < Sinatra::Base
  register Mustache::Sinatra
  require_relative 'views/layout'

  set :mustache, {
    :views => 'views',
    :templates => 'templates'
  }

  get '/' do
    mustache :home
  end

end
