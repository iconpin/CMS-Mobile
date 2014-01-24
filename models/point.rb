require 'data_mapper'

class CMS
  module Models
    class Point
      include DataMapper::Resource
      property :id, Serial
      property :name, String, :length => 255, :required => true, :unique => true
      property :description, Text, :required => true
      property :coord_x, Decimal, :required => true
      property :coord_y, Decimal, :required => true
      property :weight, Integer, :required => true, :default => 0
      property :created_at, DateTime, :required => true
      property :updated_at, DateTime, :required => true

      has n, :multimedias
    end
  end
end
