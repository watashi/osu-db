require 'osu-db/common'

module Osu
  module DB
    class Beatmap
      attr_reader :artist, :artist2, :title, :title2, :creator,
                  :difficulty, :mp3file, :beatmapcode, :osufile,
                  :type, :circles, :sliders, :spinners,
                  :unknown1, :timing_points, :unknown2,
                  :source, :tags, :unknown3, :style,
                  :flag, :time1, :nil1, :path, :time2, :nil2, :unknown4

      def initialize(ios = nil)
        load(ios) if ios
      end

      def load(ios)
        @artist      = ios.read_str
        @artist2     = ios.read_str
        @title       = ios.read_str
        @title2      = ios.read_str
        @creator     = ios.read_str
        @difficuly   = ios.read_str
        @mp3file     = ios.read_str
        @beatmapcode = ios.read_str
        @osufile     = ios.read_str

        @type        = ios.read_int 1
        @circles     = ios.read_int 2
        @slides      = ios.read_int 2
        @spinners    = ios.read_int 2
        @unknown1    = ios.read 32

        n = ios.read_int 4
        @timing_points = Array.new(n) do
          ios.read 17
        end

        @unknown2    = ios.read 23
        @source      = ios.read_str
        @tags        = ios.read_str
        @unknown3    = ios.read 2
        @style       = ios.read_str

        @flag        = ios.read_int 1
        @time1       = ios.read_time
        @nil1        = ios.read_str
        @path        = ios.read_str
        @time2       = ios.read_time
        @nil2        = ios.read_str
        @unknown4    = ios.read 9
      end
    end
  end
end
