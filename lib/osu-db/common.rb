require 'stringio'
require 'osu-db/mods'
require 'osu-db/timeutil'
require 'osu-db/timing_point'

module Osu
  module DB
    # There are mainly three different beatmap types:
    # +:Ranked+:: beatmap with a heart icon
    # +:Approved+:: beatmap with a flame icon
    # +:Pending+:: others, including pending, mod requests and graveyard
    # There is also a special type:
    # +:ToBeDecided+:: the type information in osu!.db is out of date
    BeatmapType = {
      0 => :ToBeDecided,  # Type info is out of date
      2 => :Pending,
      4 => :Ranked,
      5 => :Approved
    }

    # There are four game modes in osu!:
    # +:osu!+:: http://osu.ppy.sh/wiki/Standard
    # +:Taiko+:: http://osu.ppy.sh/wiki/Taiko
    # +:CatchTheBeat+:: http://osu.ppy.sh/wiki/Catch_The_Beat
    # <tt>:'osu!mania'</tt>:: http://osu.ppy.sh/wiki/Osu!mania
    GameMode = [
      :osu!,
      :Taiko,
      :CatchTheBeat,
      :'osu!mania'
    ]

    class UnsupportedVersionError < RuntimeError
    end

    class DBCorruptError < RuntimeError
    end

    class StringIO < ::StringIO
      def unpack(bytesize, format)
        read(bytesize).unpack(format)
      end

      def read_int(bytesize)
        unpack(bytesize, "C#{bytesize}").reverse.inject{|h, l| h << 8 | l}
      end

      def read_signed_int(bytesize)
        len = 8 * bytesize
        ret = read_int(bytesize)
        ret[len - 1] == 0 ? ret : ret - (1 << len)
      end

      def read_float
        unpack(4, 'e')[0]
      end

      def read_double
        unpack(8, 'E')[0]
      end

      def read_bool
        flag = read_int(1)
        if flag == 0 || flag == 1
          flag != 0
        else
          raise DBCorruptError, "0x00 or 0x01 expected, got #{'0x%02x' % flag}"
        end
      end

      def read_7bit_encoded_int
        ret, off = 0, 0
        loop do
          byte = read_int(1)
          ret |= (byte & 0x7F) << off
          off += 7
          break if byte & 0x80 == 0
        end
        ret
      end

      def read_time
        ticks = read_int(8)
        ticks == 0 ? nil : TimeUtil.ticks_to_time(ticks)
      end

      def read_str
        tag = read_int(1)
        if tag == 0
          nil
        elsif tag == 0x0b
          len = read_7bit_encoded_int
          read(len)
        else
          raise DBCorruptError, "0x00 or 0x0b expected, got #{'0x%02x' % tag}"
        end
      end

      VERSION_MIN = 0x01330689
      VERSION_MAX = 0x01332946

      def read_version
        version = read_int(4)
        if (VERSION_MIN .. VERSION_MAX).include? version
          version
        else
          raise UnsupportedVersionError, "version = #{'0x%08x' % version}"
        end
      end
    end
  end
end
