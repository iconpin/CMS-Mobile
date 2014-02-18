module CMS
  module Models
    class PointExtra
      include DataMapper::Resource

      property :weight, Integer, :required => true

      belongs_to :point, :key => true
      belongs_to :extra, :key => true

      before :create do |record|
        record.weight = PointExtra.first(:owner => self.owner, :order => [:weight.asc]).weight + 1
      end
    end
  end
end
