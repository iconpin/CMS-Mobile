module CMS
  module Models
    module Core
      module SortFields
        def self.included cls
          cls.class_eval do
            property :weight, Integer

            before :create do |sortable|
              sortable.weight = self.class.max_weight + 1
            end

            def self.all_sorted
              self.all(:order => [:weight.asc])
            end

            def up!(hsh = {})
              return false if self.weight == 1

              next_sortable = self.class.first({:weight => (self.weight - 1)}.merge(hsh))
              return false if next_sortable.nil?

              next_sortable.weight = self.weight
              self.weight -= 1

              return self.save && next_sortable.save
            end

            def down!(hsh = {})
              return false if self.weight == self.class.max_weight(hsh)

              next_sortable = self.class.first({:weight => (self.weight + 1)}.merge(hsh))
              return false if next_sortable.nil?

              next_sortable.weight = self.weight
              self.weight += 1

              return self.save && next_sortable.save
            end

            def self.max_weight(hsh = {})
              heaviest_record = self.first({:order => [:weight.desc]}.merge(hsh))
              if heaviest_record.nil?
                0
              else
                heaviest_record.weight
              end
            end

            def self.min_weight(hsh = {})
              heaviest_record = self.first({:order => [:weight.asc]}.merge(hsh))
              if heaviest_record.nil?
                0
              else
                heaviest_record.weight
              end
            end
          end
        end
      end
    end
  end
end
