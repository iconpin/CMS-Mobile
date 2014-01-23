class CMS
  module Views
    class Home < Layout
      def content
        if user.nil?
          "Welcome. We're running Sinatra + Mustache"
        else
          "Welcome #{user}. We're running Sinatra + Mustache"
        end
      end
    end
  end
end
