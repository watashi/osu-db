require 'osu-db/common'
require 'osu-db/score'

module Osu
  module DB
    class ScoreDB
      attr_reader :scores

      def load(str)
        ios = StringIO.new(str, "rb")
        @scores = Hash.new{[]}

        ios.version!
        n = ios.readint(4)

        n.times do
          beatmapcode = ios.readstr
          m = ios.readint(4)
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
