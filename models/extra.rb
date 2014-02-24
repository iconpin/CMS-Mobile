module CMS
  module Models
    class Extra < Group
      include Core::SortFields

      before :destroy do |extra|
        PointExtra.all(:extra => extra).each do |pe|
          pe.destroy
        end
      end

      def extra_multimedias
        self.group_multimedias
      end

      def link
        "/extra?id=#{self.id}"
      end

      def edit_link
        "/extra/edit?id=#{self.id}"
      end

      def multimedia_link
        "/extra/multimedia?id=#{self.id}"
      end
    end
  end
end
