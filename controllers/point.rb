class CMS
  module Controllers
    class Point
      def self.get params
        id = params['id']
        point = Models::Point.get(id)
        if point.nil?
          @flash.error = "El punt no existeix"
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
          @flash.success = "Punt creat amb èxit"
          true
        else
          @flash.error = "No s'ha pogut crear el punt: #{point.errors.on(:coord_x)}"
          false
        end
      end

      def self.destroy params
        id = params['id']
        point = Models::Point.get(id)
        if point.nil?
          @flash.error = "El punt no existeix"
          false
        elsif point.destroy
          @flash.success = "Punt eliminat amb èxit"
          true
        else
          @flash.error = "El punt no s'ha pogut eliminar"
          false
        end
      end

      def self.publish params
        id = params['id']
        point = Models::Point.get(id)
        if point.nil?
          @flash.error = "El punt no existeix"
          return false
        end

        point.published = true

        if point.save
          @flash.success = "Punt publicat amb èxit"
          true
        else
          @flash.error = "No s'ha pogut publicar el punt"
          false
        end
      end

      def self.unpublish params
        id = params['id']
        point = Models::Point.get(id)
        if point.nil?
          @flash.error = "El punt no existeix"
          return false
        end

        point.published = false

        if point.save
          @flash.success = "Punt ocultat amb èxit"
          true
        else
          @flash.error = "No s'ha pogut ocultar el punt"
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
          @flash.error = "El punt no existeix"
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
          @flash.success = "Punt actualitzat amb èxit"
          return true
        else
          @flash.error = "No s'ha pogut actualitzar el punt"
          return false
        end
      end
    end
  end
end
