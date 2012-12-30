require 'forwardable'
require 'osu-db/common'
require 'osu-db/beatmap'

module Osu
  module DB
    class BeatmapDB
      include Enumerable
      extend Forwardable

      def_delegators :beatmaps, :each

      attr_reader :beatmaps

      def load(str)
        ios = StringIO.new(str, 'rb')
        ios.read_version

        folders = ios.read_int 4
        dummy1  = ios.read_int 4
        dummy2  = ios.read_int 4
        dummy3  = ios.read_int 1
        user    = ios.read_str

        n = ios.read_int 4
        @beatmaps = Array.new(n) do
          beatmap = Beatmap.new(ios)
        end
      end
    end
  end
end
