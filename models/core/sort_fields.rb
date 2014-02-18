module CMS
  module Models
    module Core
      module SortFields
        def self.included cls
          cls.class_eval do
            property :weight, Integer, :required => true

            before :create do
              self.weight = self.class.first(:order => [:weight.desc]).weight + 1
            end

            def self.all_sorted
              self.all(:order => [:weight.asc])
            end
          end
        end
      end
    end
  end
end
