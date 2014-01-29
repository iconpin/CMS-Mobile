require 'sinatra/base'
require 'rack/flash'
require 'data_mapper'
require 'warden'
require 'mustache/sinatra'


class CMS < Sinatra::Base
  # Storage config
  MULTIMEDIA_DIR = "#{Dir.pwd}/storage/multimedia"
  TMP_DIR = "#{Dir.pwd}/storage/tmp"

  # DataMapper configuration
  require_relative 'models/user'
  require_relative 'models/point'
  require_relative 'models/multimedia'

  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/database.db")
  DataMapper.finalize

  Models::User.auto_upgrade!
  Models::Point.auto_upgrade!
  Models::Multimedia.auto_upgrade!

  # Warden configuration
  use Rack::Session::Cookie, :secret => "i2cheese"

  use Warden::Manager do |config|
    config.serialize_into_session { |user| user.id }
    config.serialize_from_session { |id| Models::User.get(id) }
    config.scope_defaults :default,
                          :strategies => [:password],
                          :action => 'unauthenticated'
    config.failure_app = self
  end

  # Controllers
  require_relative 'controllers/user'
  require_relative 'controllers/point'
  require_relative 'controllers/multimedia'

  Warden::Manager.before_failure do |env, opts|
    env['REQUEST_METHOD'] = 'POST'
  end

  Warden::Strategies.add(:password) do
    def valid?
      params['email'] && params['password']
    end

    def authenticate!
      user = Models::User.first(:email => params['email'])

      if user.nil?
        fail!("No hi ha cap usuari amb el correu electrònic introduït")
      elsif user.authenticate(params['password'])
        user.update(:last_login => Time.now)
        success!(user)
      else
        fail!("No s'ha pogut fet login")
      end
    end
  end

  # Rack::Flash configuration
  #enable :sessions
  use Rack::Flash, :accessorize => [:error, :success, :info]


  # Mustache configuration
  register Mustache::Sinatra

  require_relative 'views/layout'
  require_relative 'views/home'
  require_relative 'views/email'
  require_relative 'views/register'
  require_relative 'views/login'
  require_relative 'views/users'
  require_relative 'views/user_create'
  require_relative 'views/multimedia'
  require_relative 'views/image_create'
  require_relative 'views/points'
  require_relative 'views/point_create'
  require_relative 'views/point_edit'

  set :mustache, {
    :views => 'views',
    :templates => 'templates'
  }

  # Require workers
  require_relative 'workers/image_converter'

  # Utils
  require_relative 'utils/coordinates'

  before do
    @current_user = env['warden'].user || Models::Guest.new
    @flash = flash
  end

  helpers do
    def protect!
      env['warden'].authenticate!
      @flash.success = "T'has identificat amb èxit"
    end

    def admin! msg
      env['warden'].authenticate!
      unless @current_user.admin?
        flash.error = msg || "No ets usuari administrador"
        redirect '/'
      end
    end

  end

  get '/' do
    unless Controllers::User.has_admin?
      flash.info = "Aquest nou usuari serà l'administrador"
      redirect '/register'
    end

    mustache :home
  end

  get '/register' do
    mustache :register
  end

  post '/register' do
    user = Controllers::User.create_admin(params)

    if user.nil?
      redirect '/register'
    else
      redirect '/login'
    end
  end

  get '/user/create' do
    admin! "Un usuari no administrador no pot crear nous usuaris"
    mustache :user_create
  end

  post '/user/create' do
    admin! "Un usuari no administrador no pot crear nous usuaris"

    user = Controllers::User.create(params)

    if user.nil?
      redirect '/user/create'
    else
      redirect '/users'
    end
  end

  post '/user/destroy' do
    admin! "Un usuari no administrador no pot esborrar usuaris"

    Controllers::User.destroy(params['email'])
    redirect '/users'
  end

  get '/login' do
    mustache :login
  end

  post '/login' do
    protect!

    if session[:return_to].nil?
      redirect '/'
    else
      redirect session[:return_to]
    end
  end

  get '/logout' do
    env['warden'].raw_session.inspect
    env['warden'].logout
    flash.success = "Has sortit amb èxit"
    redirect '/'
  end

  post '/logout' do
    redirect '/logout'
  end

  post '/unauthenticated' do
    session[:return_to] = env['warden.options'][:attempted_path]
    redirect '/login'
  end

  get '/users' do
    admin! "Un usuari no administrador no pot gestionar usuaris"

    mustache :users
  end

  get '/image/create' do
    protect!

    mustache :image_create
  end

  post '/image/create' do
    protect!

    if Controllers::Multimedia.upload_image params
      redirect '/multimedia'
    else
      redirect '/image/create'
    end
  end

  get '/video/create' do
    protect!

    mustache :video_create
  end

  post '/video/create' do
    protect!
    # TODO
  end

  get '/multimedia' do
    protect!

    mustache :multimedia
  end

  post '/multimedia/destroy' do
    protect!

    Controllers::Multimedia.destroy(params)
    redirect '/multimedia'
  end

  get '/points' do
    protect!

    mustache :points
  end

  get '/point/create' do
    protect!

    mustache :point_create
  end

  post '/point/create' do
    protect!

    if Controllers::Point.create(params)
      redirect '/points'
    else
      redirect '/point/create'
    end
  end

  post '/point/destroy' do
    protect!

    Controllers::Point.destroy(params)
    redirect '/points'
  end

  post '/point/publish' do
    protect!

    Controllers::Point.publish(params)
    redirect '/points'
  end

  post '/point/unpublish' do
    protect!

    Controllers::Point.unpublish(params)
    redirect '/points'
  end

  get '/point/edit' do
    protect!

    @current_point = Controllers::Point.get(params)
    if @current_point.nil?
      redirect '/points'
    end

    mustache :point_edit
  end

  post '/point/edit' do
    protect!

    if Controllers::Point.edit(params)
      redirect '/points'
    else
      redirect_back
    end
  end
end
