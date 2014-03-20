#!/usr/bin/env ruby

require 'pathname'
require_relative '../app'

root = Pathname(CMS::App.root)
puts "Root: #{root}"

def normalize path
  File.join('storage', path.split('storage/').last)
end

CMS::Models::Multimedia.all.each do |m|
  path =  m.path.to_s.strip
  path_tmp =  m.path_tmp.to_s.strip
  path_thumbnail =  m.path_thumbnail.to_s.strip

  m.path = normalize(path) unless path.empty?
  m.path_tmp = normalize(path_tmp) unless path_tmp.empty?
  m.path_thumbnail = normalize(path_thumbnail) unless path_thumbnail.empty?

  puts "#{m.path}\t#{m.path_tmp}\t#{m.path_thumbnail}"
  puts m.save
end
