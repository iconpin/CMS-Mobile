class CMS
  module Controllers
    class Point
      def self.get params
        id = params['id']
        point = Models::Point.get(id)
        if point.nil?
          nil
        else
          point
        end
      end

      def self.create params
        name = params['name']
        description = params['description']
        coord_x, coord_y = Utils::Coordinates.parse(params['coords'])

        point = Models::Point.create(
          :name => name,
          :description => description,
          :coord_x => coord_x,
          :coord_y => coord_y,
          :created_at => Time.now,
          :updated_at => Time.now
        )

        if point.saved?
          true
        else
          false
        end
      end

      def self.destroy params
        id = params['id']
        point = Models::Point.get(id)
        if point.nil?
          false
        elsif point.destroy
          true
        else
          false
        end
      end

      def self.publish params
        id = params['id']
        point = Models::Point.get(id)
        if point.nil?
          return false
        end

        point.published = true

        if point.save
          true
        else
          false
        end
      end

      def self.unpublish params
        id = params['id']
        point = Models::Point.get(id)
        if point.nil?
          return false
        end

        point.published = false

        if point.save
          true
        else
          false
        end
      end

      def self.edit params
        id = params['id']
        name = params['name']
        description = params['description']
        coord_x, coord_y = Utils::Coordinates.parse(params['coords'])
        published = (params['published'] == 'on')
        multimedia_main = params['multimedia-main']

        point = Models::Point.get(id)
        if point.nil?
          return false
        end

        success = point.update(
          :name => name,
          :description => description,
          :coord_x => coord_x,
          :coord_y => coord_y,
          :updated_at => Time.now,
          :published => published
        )
        if success
          return true
        else
          return false
        end
      end
    end
  end
end
