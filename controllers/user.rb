require_relative '../models/user.rb'

class CMS
  module Controllers
    class User
      def self.create_admin params
        params['admin'] = 'on'
        create(params)
      end

      def self.create params
        name = params['name']
        password = params['password']
        password_confirm = params['password_confirm']
        email = params['email']
        admin = (params['admin'] == 'on')

        return nil unless password == password_confirm

        user = Models::User.create(
          :name => name,
          :email => email,
          :password => password,
          :created_at => Time.now,
          :updated_at => Time.now,
          :admin => admin
        )
        if user.saved?
          @flash.success = if admin
                             "Usuari administrador #{email} creat amb èxit"
                           else
                             "Usuari #{email} creat amb èxit"
                           end
          return user
        else
          return nil
        end
      end

      def self.destroy email
        user = Models::User.first(:email => email)
        if user.nil?
          @flash.error = "L'usuari no existeix"
          return false
        end

        if user == @current_user
          @flash.error = "No pots esborrar-te a tu mateix"
          return false
        end

        if user.destroy
          @flash.success = "Usuari esborrat amb èxit"
          return true
        else
          @flash.error = "No s'ha pogut esborrar l'usuari"
          return false
        end
      end

      def self.has_admin?
        Models::User.has_admin?
      end
    end
  end
end