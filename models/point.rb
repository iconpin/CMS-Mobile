require 'data_mapper'

class CMS
  module Models
    class Point
      include DataMapper::Resource
      property :id, Serial
      property :name, String, :length => 255, :required => true, :unique => true
      property :description, Text, :required => true
      property :coord_x, Float, :required => true
      property :coord_y, Float, :required => true
      property :weight, Integer, :required => true, :default => 0
      property :created_at, DateTime, :required => true
      property :updated_at, DateTime, :required => true
      property :published, Boolean, :required => true, :default => false
      property :deleted_at, ParanoidDateTime

      has n, :multimedias
    end
  end
end
