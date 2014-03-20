module CMS
  # Storage config
  multimedia_dir = File.join(App.root,'/storage/multimedia')
  tmp_dir = File.join(App.root, '/storage/tmp')
  thumbnail_dir = File.join(App.root, '/storage/thumbnail')

  # Normalization of paths
  def self.normalize path
    root = Pathname(CMS::App.root)
    Pathname(path).relative_path_from(root).to_s
  end

  MULTIMEDIA_DIR = normalize(multimedia_dir)
  TMP_DIR = normalize(tmp_dir)
  THUMBNAIL_DIR = normalize(thumbnail_dir)
end
