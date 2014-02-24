require 'builder'

module CMS
  module Routes
    class API < Base
      before do
        content_type 'text/xml'
      end

      get '/api' do
        redirect '/api/info'
      end

      get '/api/info' do
        builder do |xml|
          xml.instruct!
          xml.info :time => DateTime.now do
            xml.status "UP"
            xml.points "/api/points"
            xml.extras "/api/extras"
          end
        end
      end

      get '/api/points' do
        builder do |xml|
          xml.instruct!
          xml.points do
            CMS::Models::Point.published.not_deleted.all(
              :published => true, :order => [:weight.desc]
            ).each_with_index do |p, i|
              xml.point({
                :order => i + 1,
                :id => p.id,
                :name => p.name,
                :url => "/api/point/#{p.id}"
              })
            end
          end
        end
      end

      get '/api/point/:id' do |id|
        p = CMS::Models::Point.get(id)
        builder do |xml|
          xml.instruct!
          xml.point :name => p.name, :id => p.id do
            xml.description p.description
            xml.multimedias do
              p.multimedias_sorted.each_with_index do |m, i|
                xml.multimedia :order => i + 1, :id => m.id, :name => m.name do
                  xml.description m.description
                  xml.tip m.tip
                  xml.url m.static_link
                end
              end
            end
            xml.extras do
              p.extras_sorted.each_with_index do |e, i|
                xml.extra :order => i + 1, :id => e.id, :name => e.name do
                  xml.description e.description
                  xml.url "/api/extra/#{e.id}"
                end
              end
            end
          end
        end
      end
    end
  end
end
