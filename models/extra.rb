module CMS
  module Models
    class Extra < Group
      include Core::SortFields

      def self.all_sorted
        self.all
      end

      def link
        "/extra?id=#{self.id}"
      end
    end
  end
end
