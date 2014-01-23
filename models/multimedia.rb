require 'data_mapper'

class CMS
  module Models
    class Multimedia
      include DataMapper::Resource
      property :id, Serial
      property :name, String, :required => true
      property :created_at, DateTime
      property :updated_at, DateTime
    end
  end
end
