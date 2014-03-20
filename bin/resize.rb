#!/usr/bin/env ruby

require 'mini_magick'
require 'streamio-ffmpeg'

module CMS
  module Tools
    def self.resize_video input_path, output_path, thumbnail_path
      movie = FFMPEG::Movie.new input_path

      movie.transcode(
        output_path,
        {
          :video_codec => 'libx264',
          :x264_vprofile => 'baseline',
          :audio_codec => 'libvo_aacenc',
          :custom => '-filter:v "scale=iw*min(480/iw\,320/ih):ih*min(480/iw\,320/ih), pad=480:320:(480-iw*min(480/iw\,320/ih))/2:(320-ih*min(480/iw\,320/ih))/2"'
        }
      )

      movie = FFMPEG::Movie.new output_path
      movie.screenshot(
        thumbnail_path,
        { :resolution => '512x512' },
        :preserve_aspect_ratio => :width
      )

      image = MiniMagick::Image.open thumbnail_path
      result = image.composite(MiniMagick::Image.open('play.png')) do |c|
        c.gravity 'center'
      end
      result.write thumbnail_path
      cmd = "convert #{thumbnail_path} -type TrueColorMatte -define png:color-type=6 #{thumbnail_path}"
      Kernel.system(cmd)
    end
  end
end

'-filter:v "scale=iw*min(480/iw\,320/ih):ih*min(480/iw\,320/ih), pad=480:320:(480-iw*min(480/iw\,320/ih))/2:(320-ih*min(480/iw\,320/ih))/2"'
puts '-filter:v "scale=iw*min(480/iw\,320/ih):ih*min(480/iw\,320/ih), pad=480:320:(480-iw*min(480/iw\,320/ih))/2:(320-ih*min(480/iw\,320/ih))/2"'
