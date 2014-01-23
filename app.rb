require 'sinatra/base'
require 'warden'
require 'rack/flash'
require 'mustache/sinatra'
require 'data_mapper'
require 'pony'


class CMS < Sinatra::Base
  # Mustache configuration
  register Mustache::Sinatra

  require_relative 'views/layout'
  require_relative 'views/home'
  require_relative 'views/email'
  require_relative 'views/register'
  require_relative 'views/login'

  set :mustache, {
    :views => 'views',
    :templates => 'templates'
  }

  # DataMapper configuration
  require_relative 'models'

  DataMapper::setup(:default, "sqlite3://#{Dir.pwd}/database.db")
  DataMapper.finalize

  CMS::Models::User.auto_upgrade!

  # Warden configuration
  use Rack::Session::Cookie, :secret => "i2cheese"
  use Rack::Flash, :accessorize => [:error, :success]

  use Warden::Manager do |config|
    config.serialize_into_session { |user| user.id }
    config.serialize_from_session { |id| User.get(id) }
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
      params['name'] && params['password']
    end

    def authenticate!
      user = CMS::Models::User.first(:name => params['name'])

      if user.nil?
        fail!("El nom d'usuari introduït no existeix")
        flash.error = ""
      elsif user.authenticate(params['password'])
        flash.success = "Login fet amb èxit"
        success!(user)
      else
        fail!("No s'ha pogut fet login")
      end
    end

  end

  # Mustache Flash hook
  before do
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
    email = params["email"]
    CMS::Models::User.create(
      :name => name,
      :email => email,
      :password => password
    )
    # Send email
    # Pony.mail :to => email,
    #           :from => 'cheesemousesystem@i2cat.net',
    #           :subject => 'Welcome to Cheese Mouse System',
    #           :body => mustache(:email),
    #           :via => :sendmail
    redirect '/login'
  end

  get '/login' do
    mustache :login
  end

  post '/login' do
    env['warden'].authenticate!

    flash.success = env['warden'].message

    if session[:return_to].nil?
      redirect '/'
    else
      redirect session[:return_to]
    end
  end

  get '/logout' do
    env['warden'].raw_session.inspect
    env['warden'].logout
    flash.success = "Logout fet amb èxit"
    redirect '/'
  end

  post '/logout' do
    redirect '/logout'
  end

  post '/unauthenticated' do
    session[:return_to] = env['warden.options'][:attempted_path]
    flash.error = env['warden'].message || "Has de fer login"
    redirect '/login'
  end

  get '/user/:name' do
    name = params["name"]
    user = CMS::Models::User.first(:name => name)
    # TODO
  end
end
