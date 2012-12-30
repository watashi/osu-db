require 'osu-db/common'
require 'osu-db/score'

module Osu
  module DB
    class ScoreDB
      attr_reader :scores

      def load(str)
        ios = StringIO.new(str, "rb")
        @scores = Hash.new{[]}

        ios.read_version
        n = ios.read_int(4)

        n.times do
          beatmapcode = ios.read_str
          m = ios.read_int(4)
          m.times do
            score = Score.new
            score.load(ios)
            @scores[beatmapcode] <<= score
          end
        end
      end
    end
  end
end
