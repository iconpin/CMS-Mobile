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
          :updated_at => Time.now,
          :weight => Models::Point.count + 1
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

      def self.up params
        id = params['id']

        point = Models::Point.get(id)

        return false if point.nil?
        return false if point.weight == 1

        next_point = Models::Point.first(:weight => (point.weight - 1))

        next_point.weight = point.weight
        point.weight -= 1

        return point.save && next_point.save
      end

      def self.down params
        id = params['id']

        point = Models::Point.get(id)
        return false if point.nil?
        return false if point.weight == Models::Point.count

        prev_point = Models::Point.first(:weight => (point.weight + 1))

        prev_point.weight = point.weight
        point.weight += 1

        return point.save && prev_point.save
      end

      def self.edit_multimedia params
        point = Models::Point.get(params['point'])
        return false if point.nil?

        multimedia = Models::Multimedia.get(params['multimedia'])
        return false if multimedia.nil?

        case params['action']
        when 'link'
          max_weight_multimedia = Models::PointMultimedia.first(:order => [:weight.desc])
          max_weight = if max_weight_multimedia.nil?
                         0
                       else
                         max_weight_multimedia.weight
                       end
          pm = Models::PointMultimedia.create(
            :point => point,
            :multimedia => multimedia,
            :weight => max_weight + 1
          )
          return pm.saved?
        when 'unlink'
          pm = Models::PointMultimedia.first(:point => point, :multimedia => multimedia)
          return pm.destroy
        else
          return false
        end
      end

      def self.multimedia_up params
        point = Models::Point.get(params['point'])
        return false if point.nil?
        multimedia = Models::Multimedia.get(params['multimedia'])
        return false if multimedia.nil?
        pm = Models::PointMultimedia.first(:point => point, :multimedia => multimedia)
        return false if pm.nil?
        other = Models::PointMultimedia.first(:weight.lt => pm.weight, :order => [:weight.desc])
        return false if other.nil?
        aux = other.weight
        other.weight = pm.weight
        if pm.weight == aux
          pm.weight = aux - 1
        else
          pm.weight = aux
        end
        return pm.save && other.save
      end

      def self.multimedia_down params
        point = Models::Point.get(params['point'])
        return false if point.nil?
        multimedia = Models::Multimedia.get(params['multimedia'])
        return false if multimedia.nil?
        pm = Models::PointMultimedia.first(:point => point, :multimedia => multimedia)
        return false if pm.nil?
        other = Models::PointMultimedia.first(:weight.gt => pm.weight, :order => [:weight.asc])
        return false if other.nil?
        aux = other.weight
        other.weight = pm.weight
        if pm.weight == aux
          pm.weight = aux + 1
        else
          pm.weight = aux
        end
        return pm.save && other.save
      end

      def self.edit_extra params
        point = Models::Point.get(params['point'])
        return false if point.nil?

        extra = Models::Multimedia.get(params['extra'])
        return false if extra.nil?

        case params['action']
        when 'link'
          max_weight_extra = Models::PointExtra.first(:order => [:weight.desc])
          max_weight = if max_weight_extra.nil?
                         0
                       else
                         max_weight_extra.weight
                       end
          pe = Models::PointExtra.create(
            :point => point,
            :extra => extra,
            :weight => max_weight + 1
          )
          return pe.saved?
        when 'unlink'
          pe = Models::PointExtra.first(:point => point, :extra => extra)
          return pe.destroy
        else
          return false
        end
      end
    end
  end
end
