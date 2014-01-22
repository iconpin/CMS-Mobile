require 'data_mapper'

class CMS
  module Models
    class User
      include DataMapper::Resource
      property :id, Serial
      property :name, String
      property :password, BCryptHash
      property :created_at, DateTime
    end
  end
end
