module CMS
  module Routes
    class Base < Sinatra::Base
      configure do
        set :views, App.views
        set :root, App.root
      end

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

      enable :static

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

      use Rack::Flash, :accessorize => [:error, :warning, :info, :success]

      before do
        @current_user = env['warden'].user || Models::Guest.new
        @flash = flash
        @path = :home
      end

      helpers do
        def protect!
          env['warden'].authenticate!
        end

        def admin! msg = nil
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

      post '/unauthenticated' do
        session[:return_to] = env['warden.options'][:attempted_path]
        redirect '/login'
      end
    end
  end
end
