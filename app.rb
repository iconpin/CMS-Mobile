require 'sinatra/base'
require 'rack/flash'
require 'data_mapper'
require 'warden'
require 'haml'


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
  use Rack::Flash, :accessorize => [:error, :warning, :info, :success]


  set :views, 'views'

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

    haml :home
  end

  get '/register' do
    haml :register
  end

  post '/register' do
    user = Controllers::User.create_admin(params)

    if user.nil?
      flash.error = "No s'ha pogut efectuar el registre"
      redirect '/register'
    else
      flash.success = "T'has registrat amb èxit. Ja pots entrar"
      redirect '/login'
    end
  end

  get '/user/create' do
    admin! "Un usuari no administrador no pot crear nous usuaris"
    haml :user_create
  end

  post '/user/create' do
    admin! "Un usuari no administrador no pot crear nous usuaris"

    user = Controllers::User.create(params)

    if user.nil?
      flash.error = "No s'ha pogut crear l'usuari"
      redirect '/user/create'
    else
      flash.success = "Usuari #{user.email} creat amb èxit"
      redirect '/users'
    end
  end

  post '/user/destroy' do
    admin! "Un usuari no administrador no pot esborrar usuaris"

    if Controllers::User.destroy(params['email'])
      flash.success = "Usuari #{params['email']} esborrat amb èxit"
    else
      flash.error = "No s'ha pogut esborrar l'usuari #{params['email']}"
    end
    redirect '/users'
  end

  get '/login' do
    haml :login
  end

  post '/login' do
    protect!

    flash.success = "T'has identificat amb èxit"

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

    @user_list = Models::User.all
    haml :users
  end

  get '/image/create' do
    protect!

    haml :image_create
  end

  post '/image/create' do
    protect!

    if Controllers::Multimedia.upload_image(params)
      flash.success = "Imatge creada amb èxit"
      redirect '/multimedia'
    else
      flash.error = "No s'ha pogut crear la imatge"
      redirect '/image/create'
    end
  end

  get '/video/create' do
    protect!

    haml :video_create
  end

  post '/video/create' do
    protect!

    if Controllers::Multimedia.upload_video(params)
      flash.success = "Vídeo creat amb èxit"
      redirect '/multimedia'
    else
      flash.error = "No s'ha pogut crear el vídeo"
      redirect '/video/create'
    end
  end

  get '/multimedia' do
    protect!

    @multimedia_list = Models::Multimedia.all
    haml :multimedia
  end

  post '/multimedia/destroy' do
    protect!

    if Controllers::Multimedia.destroy(params)
      flash.success = "Multimedia destruït amb èxit"
    else
      flash.error = "No s'ha pogut destruir el multimedia"
    end
    redirect '/multimedia'
  end

  get '/point' do
    protect!

    @current_point = Controllers::Point.get(params)
    if @current_point.nil?
      flash.error = "El punt no existeix"
      redirect '/points'
    else
      haml :point
    end
  end

  get '/points' do
    protect!

    @point_list = Models::Point.all(:order => [:weight.desc])
    haml :points
  end

  get '/point/create' do
    protect!

    haml :point_create
  end

  post '/point/create' do
    protect!

    if Controllers::Point.create(params)
      flash.success = "Punt creat amb èxit"
      redirect '/points'
    else
      flash.error = "No s'ha pogut crear el punt"
      redirect '/point/create'
    end
  end

  post '/point/destroy' do
    protect!

    if Controllers::Point.destroy(params)
      flash.success = "Punt esborrat amb èxit"
    else
      flash.error = "No s'ha pogut esborrar el punt"
    end
    redirect '/points'
  end

  post '/point/publish' do
    protect!

    if Controllers::Point.publish(params)
      flash.success = "Punt publicat amb èxit"
    else
      flash.error = "No s'ha pogut publicar el punt"
    end
    redirect '/points'
  end

  post '/point/unpublish' do
    protect!

    if Controllers::Point.unpublish(params)
      flash.success = "Punt ocultat amb èxit"
    else
      flash.error = "No s'ha pogut ocultar el punt"
    end
    redirect '/points'
  end

  post '/point/up' do
    protect!

    Controllers::Point.up(params)
    redirect '/points'
  end

  post '/point/down' do
    protect!

    Controllers::Point.down(params)
    redirect '/points'
  end

  get '/point/edit' do
    protect!

    @current_point = Controllers::Point.get(params)
    if @current_point.nil?
      redirect '/points'
    end

    haml :point_edit
  end

  post '/point/edit' do
    protect!

    if Controllers::Point.edit(params)
      flash.success = "Punt actualitzat amb èxit"
      redirect '/points'
    else
      flash.error = "No s'ha pogut actualitzar el punt"
      redirect_back
    end
  end
end
