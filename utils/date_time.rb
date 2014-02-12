class CMS
  module Utils
    module DateTime
      def date_time_pretty dt
        (dt + Rational(1, 24)).strftime("%Y/%m/%d %H:%M:%S")
      end

      def created_at_pretty
        date_time_pretty(self.created_at)
      end

      def updated_at_pretty
        date_time_pretty(self.updated_at)
      end
    end
  end
end
