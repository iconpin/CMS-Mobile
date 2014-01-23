require 'data_mapper'

class CMS
  module Models
    class User
      include DataMapper::Resource
      property :id, Serial
      property :name, String
      property :email, String
      property :password, BCryptHash
      property :created_at, DateTime

      validates_presence_of :name
      validates_uniqueness_of :name

      validaes_uniqueness_of :email
      validates_presence_of :email
      validates_format_of :email, :as => :email_address

      validates_presence_of :password
      validates_length_of :password, :min => 5
    end
  end
end
