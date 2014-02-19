module CMS
  module Models
    class GroupMultimedia
      include DataMapper::Resource

      property :weight, Integer, :default => 0

      belongs_to :group, 'Group', :key => true
      belongs_to :multimedia, :key => true

      before :create do |record|
        heaviest_record = GroupMultimedia.first(:group => self.group, :order => [:weight.desc])
        record.weight = if heaviest_record.nil?
                          1
                        else
                          heaviest_record.weight + 1
                        end
      end
    end
  end
end
