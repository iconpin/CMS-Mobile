require 'sinatra/base'
require 'mustache/sinatra'
require 'data_mapper'
require 'pony'


class CMS < Sinatra::Base
  register Mustache::Sinatra
  require_relative 'views/layout'
  require_relative 'views/home'
  require_relative 'views/email'

  require_relative 'models'
  enable :sessions

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

  post '/register' do
    name = request["name"]
    password = request["password"]
    email = request["email"]
    CMS::Models::User.create(
      :name => name,
      :email => email,
      :password => password
    )
    # Send email
    Pony.mail :to => email,
              :from => 'cheesemousesystem@i2cat.net',
              :subject => 'Welcome to Cheese Mouse System',
              :body => mustache(:email)
    mustache :home
  end

  post '/login' do
    name = request["name"]
    password = request["password"]
    @user = CMS::Models::User.first(
      :name => name,
      :password => password
    )
    mustache :home
  end

  get '/user/:name' do
    name = request["name"]
    user = CMS::Models::User.first(:name => name)
    # TODO
  end

end
