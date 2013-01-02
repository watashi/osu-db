require 'osu-db/common'

module Osu
  module DB
=begin rdoc
== Structure of scores.db
* *str*[rdoc-ref:StringIO#read_str] #beatmapcode: digest of Beatmap
* *str*[rdoc-ref:StringIO#read_str] #user: username
* *str*[rdoc-ref:StringIO#read_str] #scorecode: digest of Score
* *int*[rdoc-ref:StringIO#read_int] #x300, #x100, #x50:
  the number of 300s, 100s and 50s
* *int*[rdoc-ref:StringIO#read_int] #geki, #katsu, #miss:
  these attributes may have different meaning is special modes
* *int*[rdoc-ref:StringIO#read_int] #score, #combo:
  score and max combo
* *bool*[rdoc-ref:StringIO#read_bool] #perfect?:
  full combo or not
* *bitset*[rdoc-ref:StringIO#read_int] #mods:
  mods or game modifiers, see Mod and Mods
* *time*[rdoc-ref:StringIO#read_time] #datetime:
  played time
* _0xFFFFFFFF_
* *int*[rdoc-ref:StringIO#read_int] #scoreid:
  score id
=end
    class Score
      attr_reader :game_mode, :beatmapcode, :user, :scorecode,
                  :x300, :x100, :x50, :geki, :katsu, :miss,
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
        @x300, @x100, @x50, @geki, @katsu, @miss = *ios.unpack(12, 'v6')
        @score = ios.read_int(4)
        @combo = ios.read_int(2)
        @perfect = ios.read_bool
        @mods = Mods.new(ios.read_int(5))
        @datetime = ios.read_time
        @dummy = ios.read_int(4)              # TODO: always = 0xFFFFFFFF
        @scoreid = ios.read_int(4)
      end
    end

    # Score of Standard Mode
    class OsuScore < Score
      def hits
        x300 + x100 + x50 + miss
      end

      def accuracy
        (300 * x300 + 100 * x100 + 50 * x50) / (300.0 * hits)
      end

      def grade
        if x300 == hits
          :SS # SS = 100% accuracy
        elsif 10 * x300 > 9 * hits && 100 * x50 < hits && miss == 0
          :S  # S = Over 90% 300s, less than 1% 50s and no miss.
        elsif 10 * x300 > 8 * hits && miss == 0 || 10 * x300 > 9 * hits
          :A  # A = Over 80% 300s and no miss OR over 90% 300s.
        elsif 10 * x300 > 7 * hits && miss == 0 || 10 * x300 > 8 * hits
          :B  # B = Over 70% 300s and no miss OR over 80% 300s.
        elsif 10 * x300 > 6 * hits
          :C  # C = Over 60% 300s.
        else
          :D
        end
      end
    end

    # Score of Taiko Mode
    class TaikoScore < Score
      alias :great :x300
      alias :good  :x100

      def hits
        great + good + miss
      end

      def accuracy
        (great + good * 0.5) / hits
      end

      def grade
        if x300 == hits
          :SS
        elsif 10 * x300 > 9 * hits && miss == 0
          :S
        elsif 10 * x300 > 8 * hits && miss == 0 || 10 * x300 > 9 * hits
          :A
        elsif 10 * x300 > 7 * hits && miss == 0 || 10 * x300 > 8 * hits
          :B
        elsif 10 * x300 > 6 * hits
          :C
        else
          :D
        end
      end
    end

    # Score of Catch The Beat Mode
    class CTBScore < Score
      alias :droplet_miss :katsu

      def hits
        x300 + x100 + x50 + droplet_miss + miss
      end

      def accuracy
        (x300 + x100 + x50).to_f / hits
      end

      def grade
        acc = accuracy
        [0.85, :D, 0.90, :C, 0.94, :B, 0.98, :A].each_slice(2) do |a, g|
          return g if acc <= a
        end
        acc < 1 ? :S : :SS
      end
    end

    # Score of osu!mania Mode
    class ManiaScore < Score
      alias :max  :geki
      alias :x200 :katsu

      def hits
        max + x300 + x200 + x100 + x50 + miss
      end

      def accuracy
        (300 * (max + x300) + 200 * x200 + 100 * x100 + 50 * x50) / (300.0 * hits)
      end

      def grade
        acc = accuracy
        [0.70, :D, 0.80, :C, 0.90, :B, 0.95, :A].each_slice(2) do |a, g|
          return g if acc <= a
        end
        acc < 1 ? :S : :SS
      end
    end
  end
end
