module CMS
  module Models
    module Core
      module BaseFields
        def self.included cls
          cls.class_eval do
            property :id, DataMapper::Property::Serial
            property :created_at, DataMapper::Property::DateTime
            property :updated_at, DataMapper::Property::DateTime

            before :create do |record|
              record.created_at = Time.now
            end

            before :save do |record|
              record.updated_at = Time.now
            end
          end
        end
      end
    end
  end
end
