class CMS
  module Views
    class Points < Layout
      def count
        CMS::Models::Point.count
      end

      def list_point
        list = []
        CMS::Models::Point.all.each do |p|
          list << {
            :id => p.id,
            :weight => p.weight,
            :name => p.name,
            :description => p.description[0..50],
            # TODO: maybe there's a better way to add the time zone offset?
            :created_at => (p.created_at + Rational(1, 24)).strftime("%Y/%m/%d %H:%M:%S"),
            :updated_at =>  (p.updated_at + Rational(1, 24)).strftime("%Y/%m/%d %H:%M:%S"),
            :published => p.published,
            :link => "/point/#{p.id}"
          }
        end
        list
      end
    end
  end
end
