module CMS
  module Controllers
    class Extra
      @model = Models::Extra

      def self.get params
        id = params['id'] || params['extra']
        @model.get(id)
      end

      def self.create params
        name = params['name']
        description = params['description']
        tip = params['tip']

        extra = @model.create(
          :name => name,
          :description => description,
          :tip => tip,
        )

        extra.saved?
      end

      def self.destroy params
        extra = self.get(params)
        return false if extra.nil?
        extra.destroy
      end

      def self.edit params
        id = params['id']
        name = params['name']
        description = params['description']
        tip = params['tip']
        published = (params['published'] == 'on')

        extra = self.get(params)
        if extra.nil?
          return false
        end

        success = extra.update(
          :name => name,
          :description => description,
          :tip => tip,
          :published => published
        )
        if success
          return true
        else
          return false
        end
      end

      def self.up params
        extra = self.get(params)

        if extra.nil?
          false
        else
          extra.up!
        end
      end

      def self.down params
        extra = self.get(params)

        if extra.nil?
          false
        else
          extra.down!
        end
      end

      def self.edit_multimedia params
        extra = self.get(params)
        return false if extra.nil?

        multimedia = Models::Multimedia.get(params['multimedia'])
        return false if multimedia.nil?

        case params['action']
        when 'link'
          gm = Models::GroupMultimedia.create(
            :group => extra,
            :multimedia => multimedia,
          )
          return gm.saved?
        when 'unlink'
          gm = Models::GroupMultimedia.first(
            :group => extra,
            :multimedia => multimedia
          )
          return gm.destroy
        else
          return false
        end
      end

      def self.multimedia_up params
        extra = self.get(params)
        return false if extra.nil?

        multimedia = Models::Multimedia.get(params['multimedia'])
        return false if multimedia.nil?

        gm = Models::GroupMultimedia.first(:group => extra, :multimedia => multimedia)
        return false if gm.nil?

        return gm.up!(:group => extra)
      end

      def self.multimedia_down params
        extra = self.get(params)
        return false if extra.nil?

        multimedia = Models::Multimedia.get(params['multimedia'])
        return false if multimedia.nil?

        gm = Models::GroupMultimedia.first(:group => extra, :multimedia => multimedia)
        return false if gm.nil?

        return gm.down!(:group => extra)
      end
    end
  end
end
