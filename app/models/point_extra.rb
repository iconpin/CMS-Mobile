module CMS
  module Models
    class PointExtra
      include DataMapper::Resource
      include Core::SortFields

      belongs_to :point, :key => true
      belongs_to :extra, :key => true

      # Override Core::Sortfields methods and hooks
      before :create do |record|
        heaviest_record = self.class.first(:point => self.point, :order => [:weight.desc])
        record.weight = if heaviest_record.nil?
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
