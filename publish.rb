require_relative 'app'

multimedias = CMS::Models::Multimedia.all
points = CMS::Models::Point.all
extras = CMS::Models::Extra.all

[multimedias, points, extras].each do |list|
  list.each do |item|
    item.publish!
  end
end
