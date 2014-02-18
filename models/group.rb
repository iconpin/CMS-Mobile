module CMS
  module Models
    class Group < Core::Content
      property :deleted_at, ParanoidDateTime

      has n, :group_multimedias
      has n, :multimedias, :through => :group_multimedias
    end
  end
end
