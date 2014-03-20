#!/usr/bin/env ruby

require_relative '../app'

CMS::Models::Multimedia.all.each do |multimedia|
  paths = [multimedia.path, multimedia.path_tmp, multimedia.path_thumbnail]
  paths.reject {|p| p.nil?}.each do |p|
    if p.to_s.include?('cms')
      puts p
    end
  end
end
