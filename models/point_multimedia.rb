class CMS
  module Models
    class PointMultimedia
      include DataMapper::Resource

      property :weight, Integer, :required => true

      belongs_to :point, :key => true
      belongs_to :multimedia, :key => true
    end
  end
end
