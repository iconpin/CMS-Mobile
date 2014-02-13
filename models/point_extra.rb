module CMS
  module Models
    class PointExtra
      include DataMapper::Resource

      property :weight, Integer, :required => true

      belongs_to :point, :key => true
      belongs_to :extra, 'Multimedia', :key => true
    end
  end
end
