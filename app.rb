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
    unless Models::User.has_admin?
      flash.info = "Aquest nou usuari serà l'administrador"
      redirect '/register'
    end
    mustache :home
  end

  get '/register' do
    if Models::User.has_admin?
      flash.error = "Ja existeix un usuari administrador. Demana-li accés"
      redirect '/'
    end
    mustache :register
  end

  post '/register' do
    if Models::User.has_admin?
      flash.error = "Ja existeix un usuari administrador. Demana-li accés"
      redirect '/'
    end

    name = params["name"]
    password = params["password"]
    password_confirm = params["password_confirm"]
    email = params["email"]
    unless Models::User.has_admin?
      admin = true
    end
    if password != password_confirm
      flash[:error] = "Les contrasenyes no coincideixen"
      redirect '/register'
    end
    user = Models::User.create(
      :name => name,
      :email => email,
      :password => password,
      :created_at => Time.now,
      :updated_at => Time.now,
      :admin => admin
    )
    unless user.saved?
      flash.error = "Hi ha hagut un problema amb el registre. Prova un altre cop"
      redirect '/register'
    else
      flash.success = "T'has registrat amb èxit. Ara ja pots entrar"
      redirect '/login'
    end
  end

  get '/user/create' do
    admin! "Un usuari no administrador no pot crear nous usuaris"
    mustache :user_create
  end

  post '/user/create' do
    admin! "Un usuari no administrador no pot crear nous usuaris"

    name = params['name']
    password = params['password']
    password_confirm = params['password_confirm']
    email = params['email']
    admin = (params['admin'] == 'on')
    if password != password_confirm
      flash[:error] = "Les contrasenyes no coincideixen"
      redirect '/user/create'
    end
    user = Models::User.create(
      :name => name,
      :email => email,
      :password => password,
      :created_at => Time.now,
      :updated_at => Time.now,
      :admin => admin
    )
    if user.saved?
      if admin
        flash.success = "Usuari administrador creat amb èxit"
      else
        flash.success = "Usuari creat amb èxit"
      end
      redirect '/users'
    else
      flash.error = "Hi ha hagut un problema. Comprova les dades"
      redirect '/user/create'
    end
  end

  post '/user/destroy' do
    admin! "Un usuari no administrador no pot esborrar usuaris"

    email = params['email']
    if @current_user.email == email
      flash.error = "No pots esborrar-te a tu mateix"
    else
      user = Models::User.first(:email => email)
      if user.destroy
        flash.success = "Usuari #{email} esborrat amb èxit"
      else
        flash.error = "No s'ha pogut esborrar l'usuari"
      end
    end
    redirect '/users'
  end

  get '/login' do
    mustache :login
  end

  post '/login' do
    protect!

    flash.success = "T'has indentificat amb èxit"
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

    file = params['file'][:tempfile]
    filename = params['file'][:filename]
    extension = File.extname(filename)
    name = params['name']
    description = params['description']

    image = Models::Image.new(
      :name => name,
      :description => description,
      :created_at => Time.now,
      :updated_at => Time.now
    )
    image.save  # Now we'll have and ID

    image.path_tmp = File.join(TMP_DIR, "#{image.id}#{extension}")
    File.open(image.path_tmp, 'wb') do |f|
      f.write file.read
    end

    # If we're here, the upload was successful
    image.path = File.join(MULTIMEDIA_DIR, "/#{image.id}.jpg")
    if image.save
      Workers::ImageConverter.perform_async(image.id)  # First Sidekiq usage here!
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

    id = params['id']
    multimedia = Models::Multimedia.get(id)
    if multimedia.nil?
      flash.error = "El multimedia especificat no existeix"
      redirect '/multimedia'
    elsif multimedia.destroy
      flash.success = "El multimedia s'ha esborrat amb èxit"
      redirect '/multimedia'
    else
      flash.error = "El multimedia especificat no s'ha pogut eliminar"
      redirect '/multimedia'
    end
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

    name = params['name']
    description = params['description']
    coord_x, coord_y = Utils::Coordinates.parse(params['coords'])

    point = Models::Point.create(
      :name => name,
      :description => description,
      :coord_x => coord_x,
      :coord_y => coord_y,
      :created_at => Time.now,
      :updated_at => Time.now
    )

    if point.saved?
      flash.success = "Punt creat amb èxit"
      redirect '/points'
    else
      flash.error = "No s'ha pogut crear el punt: #{point.errors.on(:coord_x)}"
      redirect '/point/create'
    end
  end

  post '/point/destroy' do
    protect!

    id = params['id']
    point = Models::Point.get(id)
    if point.nil?
      flash.error = "El punt no existeix"
      redirect '/points'
    end

    if point.destroy
      flash.success = "Punt eliminat amb èxit"
    else
      flash.error = "El punt no s'ha pogut eliminar"
    end
    redirect '/points'
  end

  post '/point/publish' do
    protect!

    id = params['id']
    point = Models::Point.get(id)
    if point.nil?
      flash.error = "El punt no existeix"
      redirect '/points'
    end

    point.published = true

    if point.save
      flash.success = "Punt publicat amb èxit"
    else
      flash.error = "No s'ha pogut publicar el punt"
    end
    redirect '/points'
  end

  post '/point/unpublish' do
    protect!

    id = params['id']
    point = Models::Point.get(id)
    if point.nil?
      flash.error = "El punt no existeix"
      redirect '/points'
    end

    point.published = false

    if point.save
      flash.success = "Punt ocultat amb èxit"
    else
      flash.error = "No s'ha pogut ocultar el punt"
    end
    redirect '/points'
  end

  get '/point/edit' do
    protect!

    id = params['id']
    point = Models::Point.get(id)
    if point.nil?
      flash.error = "El punt no existeix"
      redirect '/points'
    end

    @current_point = point

    mustache :point_edit
  end

  post '/point/edit' do
    protect!

    id = params['id']
    name = params['name']
    description = params['description']
    coord_x, coord_y = Utils::Coordinates.parse(params['coords'])
    published = (params['published'] == 'on')
    multimedia_main = params['multimedia-main']
    multimedia_main.each do |m|
      puts m
    end

    point = Models::Point.get(id)
    if point.nil?
      flash.error = "El punt no existeix"
      redirect '/points'
    end

    success = point.update(
      :name => name,
      :description => description,
      :coord_x => coord_x,
      :coord_y => coord_y,
      :updated_at => Time.now,
      :published => published
    )
    if success
      flash.success = "Punt actualitzat amb èxit"
      redirect '/points'
    else
      flash.error = "No s'ha pogut actualitzar el punt"
      redirect_back
    end
  end
end
