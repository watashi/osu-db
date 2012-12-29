require 'osu-db/common'

module Osu
  module DB
    class Score
      attr_reader :flag, :beatmapcode, :user, :scorecode,
                  :x300, :x100, :x50, :geki, :katsu, :misses,
                  :score, :combo, :mods, :datetime, :dummy, :scoreid

      def load(ios)
        @flag = ios.readint(1)
        ios.version!

        @beatmapcode = ios.readstr
        @user = ios.readstr

        @scorecode = ios.readstr
        @x300, @x100, @x50, @geki, @katsu, @misses = *ios.unpack(12, 'v6')
        @score = ios.readint(4)
        @combo = ios.readint(2)
        @mods = ios.readint(6)
        @datetime = ios.readint(8)
        @dummy = ios.readint(4)
        @scoreid = ios.readint(4)
      end
    end
  end
end