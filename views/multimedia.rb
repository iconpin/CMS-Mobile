class CMS
  module Views
    class Multimedia < Layout
      def list_multimedia
        list = []
        CMS::Models::Multimedia.all.each do |m|
          list << {
            :id => m.id,
            :weight => m.weight,
            :name => m.name,
            :description => m.description[0..50],
            # TODO: maybe there's a better way to add the time zone offset?
            :created_at => (m.created_at + Rational(1, 24)).strftime("%Y/%m/%d %H:%M:%S"),
            :updated_at =>  (m.updated_at + Rational(1, 24)).strftime("%Y/%m/%d %H:%M:%S"),
            :published => m.published,
            :ready => m.ready
          }
        end
        list
      end
    end
  end
end
