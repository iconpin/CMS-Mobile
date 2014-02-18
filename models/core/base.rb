module CMS
  module Models
    module Core
      class Base
        include DataMapper::Resource
        include Utils::DateTime

        property :id, Serial
        property :created_at, DateTime
        property :updated_at, DateTime

        before :create do |base|
          base.created_at = Time.now
        end

        before :save do |base|
          base.updated_at = Time.now
        end
      end
    end
  end
end
