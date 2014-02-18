module CMS
  module Models
    class Group
      include Core::ContentFields

      property :deleted_at, ParanoidDateTime

      has n, :group_multimedias
      has n, :multimedias, :through => :group_multimedias
    end
  end
end
