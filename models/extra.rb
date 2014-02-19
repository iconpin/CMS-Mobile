module CMS
  module Models
    class Extra < Group
      include Core::SortFields

      def link
        "/extra?id=#{self.id}"
      end
    end
  end
end
