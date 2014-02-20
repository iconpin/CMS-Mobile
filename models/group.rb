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

      before :destroy do |group|
        group.group_multimedias.each do |gm|
          gm.destroy
        end
      end

      def self.all(hsh = {})
        super(hsh.merge(:deleted_at => nil))
      end

      def self.all_paranoia(hsh = {})
        super(hsh.merge(:deleted_at.ne => nil))
      end

      def deteled?
        if self.deleted_at.nil?
          true
        else
          false
        end
      end

      def restore
        self.deleted_at = nil
        self.save
      end
    end
  end
end
