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
            xml.text Models::Info.first.text
          end
        end
      end

      get '/api/points' do
        builder do |xml|
          xml.instruct!
          xml.points do
            Models::Point.published.not_deleted.all(
              :published => true, :order => [:weight.desc]
            ).each_with_index do |p, i|
              xml.point({
                :order => i + 1,
                :id => p.id,
                :name => p.name,
                :url => link_to("/api/point/#{p.id}")
              })
            end
          end
        end
      end

      get '/api/point/:id' do |id|
        p = Models::Point.get(id)
        builder do |xml|
          xml.instruct!
          xml.point :name => p.name, :id => p.id do
            xml.description p.description
            xml.multimedias do
              p.multimedias_sorted_published.each_with_index do |m, i|
                xml.multimedia :order => i + 1, :id => m.id, :name => m.name do
                  xml.description m.description
                  xml.tip m.tip
                  xml.url link_to(m.static_link)
                end
              end
            end
            xml.extras do
              p.extras_sorted_published.each_with_index do |e, i|
                xml.extra({
                  :order => i + 1,
                  :id => e.id,
                  :name => e.name,
                  :url => link_to("/api/extra/#{e.id}")
                })
              end
            end
          end
        end
      end

      get '/api/extra/:id' do |id|
        e = Models::Extra.get(id)
        builder do |xml|
          xml.instruct!
          xml.extra :name => e.name, :id => e.id do
            xml.description e.description
            xml.multimedias do
              e.multimedias_sorted_published.each_with_index do |m, i|
                xml.multimedia :order => i + 1, :id => m.id, :name => m.name do
                  xml.description m.description
                  xml.tip m.tip
                  xml.url link_to(m.static_link)
                end
              end
            end
          end
        end
      end

      get '/api/all' do
        builder do |xml|
          xml.instruct!
          xml.data do
            xml.info do
              xml.text Models::Info.first.text
            end
            xml.points do
              Models::Point.all_sorted.published.not_deleted.each_with_index do |point, i|
                xml.point :order => i + 1, :id => point.id do
                  xml.name point.name
                  xml.description point.description
                  xml.tip point.tip
                  xml.multimedias do
                    point.multimedias_sorted_published.each_with_index do |multimedia, i|
                      xml.multimedia :order => i + 1, :id => multimedia.id do
                        xml.name multimedia.name
                        xml.description multimedia.description
                        xml.tip multimedia.tip
                        xml.url link_to(multimedia.static_link)
                      end
                    end
                  end

                  xml.extras do
                    point.extras_sorted_published.each_with_index do |extra, i|
                      xml.extra :order => i + 1, :id => extra.id do
                        xml.name extra.name
                        xml.description extra.description
                        xml.tip extra.tip
                        xml.multimedias do
                          extra.multimedia_sorted_published.each_with_index do |multimedia, i|
                            xml.multimedia :order => i + 1, :id => multimedia.id do
                              xml.name multimedia.name
                              xml.description multimedia.description
                              xml.tip multimedia.tip
                              xml.url link_to(multimedia.static_link)
                            end
                          end
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end

      get '/api/2/all' do
        builder do |xml|
          xml.instruct!
          xml.MNACTEC do |root|
            xml.Text :id => "PoIScreenTitleId", :cat => "PUNTS D'INTERÈS" do; end
            Models::Point.all_sorted.published.not_deleted.each_with_index do |point, i|
              xml.PoI :NameId => "name#{point.id}" do
                xml.textMultimedia(
                  :type => "short",
                  :TitleId => "title#{point.id}",
                  :DescriptionID => "shortInfo#{point.id}",
                  :imagePath => "borrable"
                ) do; end
                xml.textMultimedia(
                  :type => "large",
                  :TitleId => "title#{point.id}",
                  :DescriptionID => "largeInfo#{point.id}",
                  :imagePath => "borrable"
                ) do; end

                item_paths = []
                item_texts = []
                item_tips = []
                audio_path = nil
                point.multimedias_sorted_published.each_with_index do |multimedia, j|
                  path = File.join('multimedia', File.basename(multimedia.path))
                  item_paths << {:"imagePath#{j + 1}" => path} if multimedia.image?
                  item_paths << {:"videoPath#{j + 1}" => path} if multimedia.video?
                  audio_path ||= {:audioPath => path} if multimedia.audio?
                  item_texts << {:"itemTextId#{j + 1}" => "itemText#{multimedia.id}"}
                  muncu_text_id = if multimedia.tip.nil? || multimedia.tip.strip.empty?
                                    "null"
                                  else
                                    "muncuText#{multimedia.id}"
                                  end
                  item_tips << {:"muncuTextId#{j + 1}" => muncu_text_id}
                end

                xml.imageView *item_paths, *item_texts, audio_path, *item_tips do; end

                extra_ids = []
                point.extras_sorted_published.each_with_index do |extra, j|
                  extra_ids << {:"extraId#{j + 1}" => "name#{extra.id}"}
                end

                xml.extraList *extra_ids do; end

                xml.GPSPoint :latitude => point.coord_x, :longitude => point.coord_y do; end

                ar_image_path = CMS::Static::AUGMENTED_REALITY[point.id]
                unless ar_image_path.nil?
                  xml.RA :has => true, :imagePath => ar_image_path do; end
                end
              end

              xml.Text :id => "name#{point.id}", :cat => point.name do; end
              xml.Text :id => "title#{point.id}", :cat => point.name do; end
              xml.Text :id => "shortInfo#{point.id}", :cat => point.description do; end
              xml.Text :id => "largeInfo#{point.id}", :cat => point.description do; end

              point.multimedias_sorted_published.each_with_index do |multimedia, j|
                xml.Text :id => "itemText#{multimedia.id}", :cat => multimedia.description do; end
                unless multimedia.tip.nil?
                  xml.Text :id => "muncuText#{multimedia.id}", :cat => multimedia.tip do; end
                end
              end
            end

            Models::Extra.all_sorted.published.not_deleted.each_with_index do |extra, i|
              xml.PoI :NameId => "name#{extra.id}", :Extra => true do
                xml.textMultimedia(
                  :type => "short",
                  :TitleId => "title#{extra.id}",
                  :DescriptionID => "shortInfo#{extra.id}",
                  :imagePath => "borrable"
                ) do; end
                xml.textMultimedia(
                  :type => "large",
                  :TitleId => "title#{extra.id}",
                  :DescriptionID => "largeInfo#{extra.id}",
                  :imagePath => "borrable"
                ) do; end

                item_paths = []
                item_texts = []
                item_tips = []
                extra.multimedias_sorted_published.each_with_index do |multimedia, j|
                  item_paths << {:"imagePath#{j + 1}" => File.join('multimedia', File.basename(multimedia.path))} if multimedia.image?
                  item_paths << {:"videoPath#{j + 1}" => File.join('multimedia', File.basename(multimedia.path))} if multimedia.video?

                  item_texts << {:"itemTextId#{j + 1}" => "itemText#{multimedia.id}"}
                  muncu_text_id = if multimedia.tip.nil? || multimedia.tip.strip.empty?
                                    "null"
                                  else
                                    "muncuText#{multimedia.id}"
                                  end
                  item_tips << {:"muncuTextId#{j + 1}" => muncu_text_id}
                end

                xml.imageView *item_paths, *item_texts, *item_tips do; end
              end

              xml.Text :id => "name#{extra.id}", :cat => extra.name do; end
              xml.Text :id => "title#{extra.id}", :cat => extra.name do; end
              xml.Text :id => "shortInfo#{extra.id}", :cat => extra.description do; end
              xml.Text :id => "largeInfo#{extra.id}", :cat => extra.description do; end

              extra.multimedias_sorted_published.each_with_index do |multimedia, j|
                xml.Text :id => "itemText#{multimedia.id}", :cat => multimedia.description do; end
                unless multimedia.tip.nil?
                  xml.Text :id => "muncuText#{multimedia.id}", :cat => multimedia.tip do; end
                end
              end
            end
            root << CMS::Static::EXTRA_XML_DATA
          end
        end
      end
    end
  end
end
