require 'sinatra/base'
require 'rack/flash'
require 'data_mapper'
require 'warden'
require 'mustache/sinatra'


class CMS < Sinatra::Base
  # Multimedia storage configuration
  MULTIMEDIA_DIR = './multimedia'
  TMP_DIR = './tmp'

  # DataMapper configuration
  require_relative 'models/user'
  require_relative 'models/point'
  require_relative 'models/multimedia'

  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/database.db")
  DataMapper.finalize

  CMS::Models::User.auto_upgrade!
  CMS::Models::Point.auto_upgrade!
  CMS::Models::Multimedia.auto_upgrade!

  # Warden configuration
  use Rack::Session::Cookie, :secret => "i2cheese"

  use Warden::Manager do |config|
    config.serialize_into_session { |user| user.id }
    config.serialize_from_session { |id| CMS::Models::User.get(id) }
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
      user = CMS::Models::User.first(:email => params['email'])

      if user.nil?
        fail!("No hi ha cap usuari amb el correu electrònic introduït")
      elsif user.authenticate(params['password'])
        user.update(:last_login => Time.now)
        success!(user)
      else
        flash[:error] = "El correu electrònic o la contrasenya són incorrectes"
        fail!("No s'ha pogut fet login")
      end
    end
  end

  # Rack::Flash configuration
  #enable :sessions
  use Rack::Flash, :accessorize => [:error, :success]


  # Mustache configuration
  register Mustache::Sinatra

  require_relative 'views/layout'
  require_relative 'views/home'
  require_relative 'views/email'
  require_relative 'views/register'
  require_relative 'views/login'
  require_relative 'views/users'
  require_relative 'views/image_create'

  set :mustache, {
    :views => 'views',
    :templates => 'templates'
  }

  # Sidekiq configuration
  require_relative 'workers/image_converter'


  before do
    @current_user = env['warden'].user
    @flash = flash
  end

  get '/' do
    mustache :home
  end

  get '/register' do
    mustache :register
  end

  post '/register' do
    name = params["name"]
    password = params["password"]
    password_confirm = params["password_confirm"]
    email = params["email"]
    redirect '/register' unless password == password_confirm
    success = CMS::Models::User.create(
      :name => name,
      :email => email,
      :password => password,
      :created_at => Time.now,
      :updated_at => Time.now
    )
    unless success
      flash.error = "Hi ha hagut un problema amb el registre. Prova un altre cop"
      redirect '/register'
    else
      # Send email
      # Pony.mail :to => email,
      #           :from => 'cheesemousesystem@i2cat.net',
      #           :subject => 'Welcome to Cheese Mouse System',
      #           :body => mustache(:email),
      #           :via => :sendmail
      flash.success = "T'has registrat amb èxit. Ara ja pots entrar"
      redirect '/login'
    end
  end

  get '/user/create' do
    env['warden'].authenticate!

    mustache :user_create
  end

  post '/user/create' do
    env['warden'].authenticate!

    name = params["name"]
    password = params["password"]
    password_confirm = params["password_confirm"]
    email = params["email"]
    redirect '/user/create' unless password == password_confirm
    success = CMS::Models::User.create(
      :name => name,
      :email => email,
      :password => password,
      :created_at => Time.now,
      :updated_at => Time.now
    )
    unless success
      flash.success = "Usuari creat amb èxit"
      redirect '/user/create'
    else
      flash.error = "Hi ha hagut un problema. Comprova les dades"
      redirect '/users'
    end
  end

  post '/user/delete' do
    env['warden'].authenticate!

    email = params["email"]
    if @current_user.email == email
      flash.error = "No pots esborrar-te a tu mateix"
    elsif CMS::Models::User.delete(:email => email)
      flash.success = "Usuari #{email} esborrat amb èxit"
    else
      flash.error = "No s'ha pogut esborrar l'usuari"
    end
    redirect '/users'
  end

  get '/login' do
    mustache :login
  end

  post '/login' do
    env['warden'].authenticate!

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
    flash.success = "Has sortit amb èxti"
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
    env['warden'].authenticate! # I <3 Ruby

    mustache :users
  end

  get '/point/create' do
    env['warden'].authenticate!

    mustache :point_create
  end

  post '/point/create' do
    env['warden'].authenticate!

    name = params['name']
    description = params['description']
    coord_x = params['coord_x']
    coord_y = params['coord_y']

    success = CMS::Models::Point.create(
      :name => name,
      :description => description,
      :coord_x => coord_x,
      :coord_y => coord_y,
      :created_at => Time.now,
      :updated_at => Time.now
    )

    if success
      redirect '/points'
    else
      redirect '/point/create'
    end
  end

  get '/image/create' do
    env['warden'].authenticate!

    mustache :image_create
  end

  post '/image/create' do
    env['warden'].authenticate!

    file = params['file'][:tempfile]
    filename = params['file'][:filename]
    extension = File.extname(filename)
    name = params['name']
    description = params['description']

    image = CMS::Models::Image.new(
      :name => name,
      :description => description,
      :created_at => Time.now,
      :updated_at => Time.now
    )
    image.save  # Now we'll have and ID

    image.path_tmp = File.join(CMS::TMP_DIR, "#{image.id}.#{extension}")
    File.open(image.path_tmp, 'wb') do |f|
      f.write file.read
    end

    # If we're here, the upload was successful
    image.path = File.join(CMS::MULTIMEDIA_DIR, "/#{image.id}.jpg")
    if image.save
      CMS::Workers::ImageConverter.perform_async(image.id)  # First Sidekiq usage here!
      redirect '/images'
    else
      redirect '/image/create'
    end
  end

  get '/video/create' do
    env['warden'].authenticate!

    mustache :video_create
  end

  post '/video/create' do
    env['warden'].authenticate!
    # TODO
  end

end
