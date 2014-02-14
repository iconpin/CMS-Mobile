module CMS
  module Routes
    class User < Base
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

        if Controllers::User.destroy(params['email'], @current_user)
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

      get '/users' do
        admin! "Un usuari no administrador no pot gestionar usuaris"

        @user_list = Models::User.all
        haml :users
      end
    end
  end
end
