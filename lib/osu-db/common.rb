require 'stringio'

module Osu
  module DB
    class UnsupportedVersionError < RuntimeError
    end

    class DBCorruptError < RuntimeError
    end


    class StringIO < ::StringIO
      def unpack(bytesize, format)
        read(bytesize).unpack(format)
      end

      def readint(bytesize)
        unpack(bytesize, "C#{bytesize}").reverse.inject{|h, l| h << 8 | l}
      end

      def readstr
        tag = read(1)
        if tag != "\x0b"
          raise DBCorruptError, "0x0b expected, got #{'0x%02x' % tag.ord}"
        else
          len = readint(1)
          read(len)
        end
      end

      VERSION_MIN = "\x89\x06\x33\x01".unpack('V')[0]
      VERSION_MAX = "\x8D\x06\x33\x01".unpack('V')[0]

      def version!
        version = readint(4)
        unless (VERSION_MIN .. VERSION_MAX).include? version
          raise UnsupportedVersionError, "version = #{'0x%08x' % version}"
        end
      end
    end


    # Conversion between System.DateTime.Ticks in .NET and Time in Ruby
    # http://msdn.microsoft.com/en-us/library/system.datetime.ticks.aspx
    # http://www.ruby-doc.org/core/Time.html
    # http://en.wikipedia.org/wiki/System_time
    module TimeUtil
      # A single tick represents one hundred nanoseconds or one ten-millionth
      # of a second.
      TICKS_PER_SEC = 10 ** 7

      # The value of DateTime.Ticks represents the number of 100-nanosecond
      # intervals that have elapsed since 12:00:00 midnight, January 1, 0001,
      # which represents DateTime.MinValue. It does not include the number of
      # ticks that are attributable to leap seconds.
      EPOCH_TO_TICKS = 0 - Time.utc(1, 1, 1).to_i * TICKS_PER_SEC

      def self.ticks_to_time(ticks)
        if ticks.kind_of? Numeric
          Time.at(Rational(ticks - EPOCH_TO_TICKS, TICKS_PER_SEC))
        else
          ticks
        end
      end

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
