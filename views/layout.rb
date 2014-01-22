class CMS
  module Views
    class Layout < Mustache
      def title
        @title || "Cheese Mouse System"
      end
    end
  end
end
