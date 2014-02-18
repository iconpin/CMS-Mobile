module CMS
  module Models
    class Group
      include DataMapper::Resource
      include Core::BaseFields
      include Core::ContentFields
      include Utils::DateTime

      property :deleted_at, ParanoidDateTime

      has n, :group_multimedias
      has n, :multimedias, :through => :group_multimedias
    end
  end
end
