require 'builder'

module CMS
  module Routes
    class API < Base
      get '/api/info.xml' do
        builder do |xml|
          xml.instruct!
          xml.info :time => DateTime.now do
            xml.status "UP"
          end
        end
      end

      get '/api/points.xml' do
        builder do |xml|
          xml.instruct!
          xml.points do
            CMS::Models::Point.published.not_deleted.all(
              :published => true,
              :order => [:weight.desc]
            ).each_with_index do |p, i|
              xml.point :name => p.name, :order => i + 1 do
                xml.description p.description
              end
            end
          end
        end
      end
    end
  end
end
