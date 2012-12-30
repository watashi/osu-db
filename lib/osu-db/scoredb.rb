require 'forwardable'
require 'osu-db/common'
require 'osu-db/score'

module Osu
  module DB
    class ScoreDB
      include Enumerable
      extend Forwardable

      def_delegators :scores, :each

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
            @scores[beatmapcode] <<= Score.new(ios)
          end
        end
      end
    end
  end
end
