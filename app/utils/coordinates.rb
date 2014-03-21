module CMS
  module Utils
    class Coordinates
      # <3 StackOverflow http://stackoverflow.com/a/1317231

      def self.dms_to_degrees d, m, s
        degrees = d
        fractional = m / 60 + s / 3600
        if d > 0
          degrees + fractional
        else
          degrees - fractional
        end
      end

      def self.parse text
        match = text.match(/(-?\d+)º (\d+)' (\d+)'' (-?\d+)º (\d+)' (\d+)''/)
        if match
          latitude = dms_to_degrees(*match[1..3].map {|x| x.to_f})
          longitude = dms_to_degrees(*match[4..6].map {|x| x.to_f})
        else
          latitude = text.split(",").first.to_f
          longitude = text.split(",").last.to_f
        end
        [latitude, longitude]
      end
    end
  end
end
