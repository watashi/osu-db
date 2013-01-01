require 'osu-db/common'

module Osu
  module DB
    class Score
      attr_reader :game_mode, :beatmapcode, :user, :scorecode,
                  :x300, :x100, :x50, :geki, :katsu, :misses,
                  :score, :combo, :perfect, :mods, :datetime, :dummy, :scoreid

      alias :perfect?    :perfect
      alias :full_combo  :perfect
      alias :full_combo? :full_combo

      def initialize(game_mode, ios = nil)
        @game_mode = game_mode
        load(ios) if ios
      end

      def accuracy
        raise NotImplementedError
      end

      def grade
        raise NotImplementedError
      end

      def load(ios)
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
        @dummy = ios.read_int(4)              # TODO: always = 0xFFFFFFFF
        @scoreid = ios.read_int(4)
      end
    end

    # Standard Mode
    class OsuScore < Score
    end

    # Taiko Mode
    class TaikoScore < Score
    end

    # Catch The Beat Mode
    class CTBScore < Score
      alias :droplet_miss :katsu
    end

    # osu!mania Mode
    class ManiaScore < Score
      alias :max  :geki
      alias :x200 :katsu
      alias :miss :misses
    end
  end
end
