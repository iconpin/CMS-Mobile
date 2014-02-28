module CMS
  module Models
    class Group
      include DataMapper::Resource
      include Core::BaseFields
      include Core::ContentFields
      include Utils::DateTime

      property :deleted_at, ParanoidDateTime
      property :type, Discriminator

      has n, :group_multimedias, :order => [:weight.asc]
      has n, :multimedias, :through => :group_multimedias

      before :destroy do |group|
        group.group_multimedias.each do |gm|
          gm.destroy
        end
      end

      def self.not_deleted
        self.all(:deleted_at => nil)
      end

      def self.all_paranoia(hsh = {})
        self.all(:deleted_at.ne => nil)
      end

      def deleted?
        if self.deleted_at.nil?
          false
        else
          true
        end
      end

      def restore
        self.deleted_at = nil
        self.save
      end

      def multimedias_sorted
        multimedias = []
        self.group_multimedias.all(:order => [:weight.asc]).each do |gm|
          multimedias << gm.multimedia
        end
        multimedias
      end

      def multimedias_sorted_published
        multimedias.select {|m| m.published? }
      end

      def has_image?
        self.multimedias.count(:type => Image) != 0
      end

      def has_audio?
        self.multimedias.count(:type => Audio) != 0
      end

      def has_video?
        self.multimedias.count(:type => Video) != 0
      end
    end
  end
end
