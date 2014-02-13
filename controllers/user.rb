module CMS
  module Controllers
    class User
      def self.create_admin params
        if Models::User.has_admin?
          return nil
        end
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
          return user
        else
          return nil
        end
      end

      def self.destroy email, current_user
        user = Models::User.first(:email => email)
        if user.nil?
          return false
        end

        puts "USER: #{current_user}"
        if user == current_user
          return false
        end

        if user.destroy
          return true
        else
          return false
        end
      end

      def self.has_admin?
        Models::User.has_admin?
      end
    end
  end
end
