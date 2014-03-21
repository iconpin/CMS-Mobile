module CMS
  module Models
    class Info
      include DataMapper::Resource
      include Core::BaseFields
      include Utils::DateTime

      property :text, Text
    end

    class NoInfo
      def text
        ""
      end
    end
  end
end
