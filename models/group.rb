module CMS
  module Models
    class Group
      include DataMapper::Resource
      include Core::BaseFields
      include Core::ContentFields
      include Utils::DateTime

      property :deleted_at, ParanoidDateTime
      property :type, Discriminator

      has n, :group_multimedias
      has n, :multimedias, :through => :group_multimedias

      def destroy_cascade
        self.group_multimedias.each do |gm|
          gm.destroy
        end
        puts "Before destroying!!!!!!!"
        self.destroy
      end
    end
  end
end
