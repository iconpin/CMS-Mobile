module CMS
  module Models
    module Core
      class Content < Base
        property :name, String, :length => 255, :required => true
        property :description, Text
        property :tip, Text
        property :published, Boolean, :required => true, :default => false

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
