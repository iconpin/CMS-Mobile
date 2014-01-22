require 'sinatra/base'
require 'mustache/sinatra'
require 'data_mapper'


class CMS < Sinatra::Base
  register Mustache::Sinatra
  require_relative 'views/layout'
  require_relative 'views/home'
  require_relative 'models'

  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/database.db")
  DataMapper.finalize

  CMS::Models::User.auto_upgrade!

  set :mustache, {
    :views => 'views',
    :templates => 'templates'
  }

  get '/' do
    mustache :home
  end

  post '/user/new' do
    name = request["name"]
    password = request["password"]
    # TODO validations?
    CMS::Models::User.create(
      :name => name,
      :password => password
    )
    # TODO success page
  end

  get '/user/:name' do
    name = request["name"]
    user = CMS::Models::User.first(:name => name)
    # TODO
  end

end
