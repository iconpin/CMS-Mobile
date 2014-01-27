require 'data_mapper'

class CMS
  module Models
    class User
      include DataMapper::Resource
      property :id, Serial
      property :name, String, :required => true
      property :email, String, :required => true, :unique => true
      property :password, BCryptHash, :required => true
      property :admin, Boolean, :required => true, :default => false
      property :created_at, DateTime, :required => true
      property :updated_at, DateTime, :required => true
      property :last_login, DateTime

      validates_format_of :email, :as => :email_address
      validates_length_of :password, :min => 5

      def authenticate(attempted_password)
        if self.password == attempted_password
          true
        else
          false
        end
      end

      def admin?
        self.admin
      end

      def guest?
        false
      end

      def self.has_admin?
        count(:admin => true) > 0
      end
    end

    class Guest
      def admin?
        false
      end

      def name
        "convidat/ada"
      end

      def guest?
        true
      end
    end
  end
end
