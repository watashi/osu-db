require 'osu-db/common'

module Osu
  module DB
    class Score
      attr_reader :flag, :beatmapcode, :user, :scorecode,
                  :x300, :x100, :x50, :geki, :katsu, :misses,
                  :score, :combo, :perfect, :mods, :datetime, :dummy, :scoreid

      def initialize(ios = nil)
        load(ios) if ios
      end

      def load(ios)
        @flag = ios.read_int(1)
        ios.read_version

        @beatmapcode = ios.read_str
        @user = ios.read_str

        @scorecode = ios.read_str
        @x300, @x100, @x50, @geki, @katsu, @misses = *ios.unpack(12, 'v6')
        @score = ios.read_int(4)
        @combo = ios.read_int(2)
        @perfect = ios.read_bool
        @mods = Mods.new(ios.read_int(5))
        @datetime = ios.read_time
        @dummy = ios.read_int(4)
        @scoreid = ios.read_int(4)
      end
    end
  end
end
