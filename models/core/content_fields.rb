module CMS
  module Models
    module Core
      module ContentFields
        def self.included cls
          cls.class_eval do
            include BaseFields

            property :name, DataMapper::Property::String, :length => 255, :required => true
            property :description, DataMapper::Property::Text
            property :tip, DataMapper::Property::Text
            property :published, DataMapper::Property::Boolean, :required => true, :default => false

            def published?
              self.published
            end

            def publish!
              self.published = true
              self.save
            end

            def unpublish!
              self.published = false
              self.save
            end
          end
        end
      end
    end
  end
end
