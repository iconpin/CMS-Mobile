module CMS
  module Models
    class Extra < Group
      include Core::SortFields

      def self.all_sorted
        self.all
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
