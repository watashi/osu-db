require 'osu-db/common'
require 'osu-db/score'

module Osu
  module DB
    class ScoreDB
      include Enumerable

      @@game_mode_score = {
        :osu!         => OsuScore,
        :Taiko        => TaikoScore,
        :CatchTheBeat => CTBScore,
        :'osu!mania'  => ManiaScore
      }

      attr_reader :scores

      def each
        scores.each do |_, v|
          v.each do |score|
            yield score
          end
        end
      end

      def load(str)
        ios = StringIO.new(str, "rb")
        @scores = Hash.new{[]}

        ios.read_version
        n = ios.read_int(4)

        n.times do
          beatmapcode = ios.read_str
          m = ios.read_int(4)
          m.times do
            game_mode = GameMode[ios.read_int 1]
            if game_mode && @@game_mode_score[game_mode]
              score = @@game_mode_score[game_mode].new(game_mode, ios)
            else
              score = Score.new(game_mode, ios)
            end
            @scores[beatmapcode] <<= score
          end
        end
      end
    end
  end
end
