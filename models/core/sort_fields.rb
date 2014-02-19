module CMS
  module Models
    module Core
      module SortFields
        def self.included cls
          cls.class_eval do
            property :weight, Integer, :required => true

            before :create do |sortable|
              heaviest_record = self.class.first(:order => [:weight.desc])
              sortable.weight = if heaviest_record.nil?
                                  1
                                else
                                  heaviest_record.weight + 1
                                end
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
