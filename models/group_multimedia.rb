module CMS
  module Models
    class GroupMultimedia
      include DataMapper::Resource

      property :weight, Integer, :required => true

      belongs_to :group, 'Group', :key => true
      belongs_to :multimedia, :key => true

      before :create do |record|
        record.weight = GroupMultimedia.first(:owner => self.owner, :order => [:weight.asc]).weight + 1
      end
    end
  end
end
