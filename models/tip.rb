module CMS
  module Models
    class Tip
      include DataMapper::Resource

      property :id, Serial
      property :text, Text, :required => true, :lazy => false
    end
  end
end
