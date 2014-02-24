module CMS
  module Controllers
    class Point
      @model = Models::Point

      def self.get params
        id = params['id'] || params['point']
        Models::Point.get(id)
      end

      def self.create params
        name = params['name']
        description = params['description']
        tip = params['tip']
        coord_x, coord_y = Utils::Coordinates.parse(params['coords'])

        point = @model.create(
          :name => name,
          :description => description,
          :tip => tip,
          :coord_x => coord_x,
          :coord_y => coord_y,
        )

        point.saved?
      end

      def self.destroy params
        point = self.get(params)
        return false if point.nil?
        point.destroy
      end

      def self.publish params
        id = params['id']
        point = Models::Point.get(id)
        return false if point.nil?
        if point.nil?
          false
        else
          point.publish!
        end
      end

      def self.unpublish params
        id = params['id']
        point = Models::Point.get(id)
        if point.nil?
          false
        else
          point.unpublish!
        end
      end

      def self.edit params
        point = self.get(params)
        return false if point.nil?

        name = params['name']
        description = params['description']
        tip = params['tip']
        coord_x, coord_y = Utils::Coordinates.parse(params['coords'])
        published = (params['published'] == 'on')
        multimedia_main = params['multimedia-main']

        success = point.update(
          :name => name,
          :description => description,
          :tip => tip,
          :coord_x => coord_x,
          :coord_y => coord_y,
          :published => published
        )
        if success
          return true
        else
          return false
        end
      end

      def self.up params
        point = self.get(params)
        return false if point.nil?

        point.up!
      end

      def self.down params
        point = self.get(params['id'])
        return false if point.nil?
        point.down!
      end

      def self.edit_multimedia params
        point = self.get(params)
        return false if point.nil?

        multimedia = Models::Multimedia.get(params['multimedia'])
        return false if multimedia.nil?

        case params['action']
        when 'link'
          gm = Models::GroupMultimedia.create(
            :group => point,
            :multimedia => multimedia,
          )
          gm.saved?
        when 'unlink'
          gm = Models::GroupMultimedia.first(
            :group => point,
            :multimedia => multimedia
          )
          gm.destroy
        else
          false
        end
      end

      def self.multimedia_up params
        point = self.get(params)
        return false if point.nil?

        multimedia = Models::Multimedia.get(params['multimedia'])
        return false if multimedia.nil?

        gm = Models::GroupMultimedia.first(:group => point, :multimedia => multimedia)
        return false if gm.nil?

        gm.up!(:group => point)
      end

      def self.multimedia_down params
        point = self.get(params)
        return false if point.nil?

        multimedia = Models::Multimedia.get(params['multimedia'])
        return false if multimedia.nil?

        gm = Models::GroupMultimedia.first(:group => point, :multimedia => multimedia)
        return false if gm.nil?

        gm.down!(:group => point)
      end

      def self.edit_extra params
        point = self.get(params)
        return false if point.nil?

        extra = Models::Extra.get(params['extra'])
        return false if extra.nil?

        case params['action']
        when 'link'
          pe = Models::PointExtra.create(
            :point => point,
            :extra => extra,
          )
          pe.saved?
        when 'unlink'
          pe = Models::PointExtra.first(
            :point => point,
            :extra => extra
          )
          pe.destroy
        else
          false
        end
      end

      def self.extra_up params
        point = get(params)
        return false if point.nil?

        extra = Models::Extra.get(params['extra'])
        return false if extra.nil?

        pe = Models::PointExtra.first(:point => point, :extra => extra)
        return false if pe.nil?

        pe.up!(:point => point)
      end

      def self.extra_down params
        point = get(params)
        return false if point.nil?

        extra = Models::Extra.get(params['extra'])
        return false if extra.nil?

        pe = Models::PointExtra.first(:point => point, :extra => extra)
        return false if pe.nil?

        pe.down!(:point => point)
      end
    end
  end
end
