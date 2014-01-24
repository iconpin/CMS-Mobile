require 'data_mapper'

class CMS
  module Models
    class Multimedia
      include DataMapper::Resource
      property :id, Serial
      property :name, String, :required => true
      property :weight, Integer, :required => true, :default => 0
      property :path, FilePath, :required => true
      property :published, Boolean, :required => true, :default => false
      property :created_at, DateTime, :required => true
      property :updated_at, DateTime, :required => true
    end
  end
end
