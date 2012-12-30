require 'osu-db/common'

module Osu
  module DB
    class Beatmap
      attr_reader :artist, :artist_unicode, :title, :title_unicode, :creator,
                  :version, :audio_filename, :beatmapcode, :osu_filename,
                  :type, :circles, :sliders, :spinners, :last_edit,
                  :approach_rate, :circle_size, :hp_drain_rate,
                  :overall_difficulty, :slider_multiplier, :unknown1,
                  :timing_points, :beatmapid, :beatmapsetid, :threadid,
                  :unknown2, :source, :tags, :unknown3, :style, :flag,
                  :last_play, :zero1, :path, :zero2, :last_sync, :unknown4

      def initialize(ios = nil)
        load(ios) if ios
      end

      def audio_path
        "#{path}\\#{audio_filename}"
      end

      def osu_path
        "#{path}\\#{audio_filename}"
      end

      def load(ios)
        @artist         = ios.read_str
        @artist_unicode = ios.read_str
        @title          = ios.read_str
        @title_unicode  = ios.read_str
        @creator        = ios.read_str
        @version        = ios.read_str
        @audio_filename = ios.read_str
        @beatmapcode    = ios.read_str
        @osu_filename   = ios.read_str

        # {0: ??, 2: :pending, 4: :ranked, 5: :approved}
        @type = ios.read_int 1
        @circles, @slides, @spinners = *ios.unpack(6, 'V*')
        @last_edit = ios.read_time
        # approach_rate(??) might be different from that in .osu
        @approach_rate, @circle_size, @hp_drain_rate, @overall_difficulty =
          *ios.unpack(4, 'C*')
        @slider_multiplier  = ios.read_double
        @unknown1 = ios.read 12             # ?

        n = ios.read_int 4
        @timing_points = Array.new(n) do
          bpm = ios.read_double
          offset = ios.read_double
          type = ios.read_bool
          (type ? RegularTimingPoint : InheritedTimingPoint).new(offset, bpm)
        end

        @beatmapid      = ios.read_int 4
        @beatmapsetid   = ios.read_int 4
        @threadid       = ios.read_int 4
        @unknown2       = ios.read 11       # ?
        @source         = ios.read_str
        @tags           = ios.read_str
        @unknown3       = ios.read 2        # ?
        @style          = ios.read_str      # ?

        @flag           = ios.read_int 1    # ?
        @last_play      = ios.read_time     # ?
        @zero1          = ios.read_bool     # ?
        @path           = ios.read_str
        @last_sync      = ios.read_time     # ?
        @zero2          = ios.read_bool     # ?
        @unknown4       = ios.read 9        # ?
      end
    end
  end
end
