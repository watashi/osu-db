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

      def hits
        raise NotImplementedError
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
      def hits
        x300 + x100 + x50 + misses
      end

      def accuracy
        (300 * x300 + 100 * x100 + 50 * x50) / (300.0 * hits)
      end

      def grade
        if x300 == hits
          :SS # SS = 100% accuracy
        elsif 10 * x300 > 9 * hits && 100 * x50 < hits && misses == 0
          :S  # S = Over 90% 300s, less than 1% 50s and no misses.
        elsif 10 * x300 > 8 * hits && misses == 0 || 10 * x300 > 9 * hits
          :A  # A = Over 80% 300s and no misses OR over 90% 300s.
        elsif 10 * x300 > 7 * hits && misses == 0 || 10 * x300 > 8 * hits
          :B  # B = Over 70% 300s and no misses OR over 80% 300s.
        elsif 10 * x300 > 6 * hits
          :C  # C = Over 60% 300s.
        else
          :D
        end
      end
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
