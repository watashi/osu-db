module Osu
  module DB
    # Conversion between System.DateTime.Ticks in .NET and Time in Ruby
    # - http://msdn.microsoft.com/en-us/library/system.datetime.ticks.aspx
    # - http://www.ruby-doc.org/core/Time.html
    module TimeUtil
      # A single tick represents one hundred nanoseconds or one ten-millionth
      # of a second.
      TICKS_PER_SEC = 10 ** 7

      # The value of DateTime.Ticks represents the number of 100-nanosecond
      # intervals that have elapsed since 12:00:00 midnight, January 1, 0001,
      # which represents DateTime.MinValue. It does not include the number of
      # ticks that are attributable to leap seconds.
      EPOCH_TO_TICKS = 0 - Time.utc(1, 1, 1).to_i * TICKS_PER_SEC

      # Convert DateTime.Ticks to Time
      def self.ticks_to_time(ticks)
        if ticks.kind_of? Numeric
          Time.at(Rational(ticks - EPOCH_TO_TICKS, TICKS_PER_SEC))
        else
          ticks
        end
      end

      # Convert Time to DateTime.Ticks
      def self.time_to_ticks(time)
        if time.kind_of? Numeric
          time.to_i
        else
          EPOCH_TO_TICKS + (time.to_r * TICKS_PER_SEC).to_i
        end
      end
    end
  end
end
