class CMS
  module Views
    class Email < Mustache
      def title
        @title || "Email from Cheese Mouse System"
      end

      def content
        "default email content"
      end
    end
  end
end
