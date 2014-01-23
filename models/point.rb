require 'data_mapper'

class CMS
  module Models
    class Point
      include DataMapper::Resource
      property :id, Serial
      property :name, String, :length => 255, :required => true, :unique => true
      property :description, Text, :required => true
    end
  end
end
