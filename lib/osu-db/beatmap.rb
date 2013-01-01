require 'osu-db/common'

module Osu
  module DB
    class Beatmap
      attr_reader :artist, :artist_unicode, :title, :title_unicode, :creator,
                  :version, :audio_filename, :beatmapcode, :osu_filename,
                  :type, :circles, :sliders, :spinners, :last_edit,
                  :approach_rate, :circle_size, :hp_drain_rate,
                  :overall_difficulty, :slider_multiplier,
                  :draining_time, :total_time, :preview_time,
                  :timing_points, :beatmapid, :beatmapsetid, :threadid,
                  :ratings, :your_offset, :stack_leniency, :mode,
                  :source, :tags, :online_offset, :letterbox,
                  :played, :last_play, :zero1, :path, :last_sync,
                  :ignore_hitsound, :ignore_skin, :disable_storyboard,
                  :background_dim, :zero2, :int1, :int2

      alias :played?             :played
      alias :ignore_hitsound?    :ignore_hitsound
      alias :ignore_skin?        :ignore_skin
      alias :disable_storyboard? :disable_storyboard

      def initialize(ios = nil)
        load(ios) if ios
      end

      def audio_path
        "#{path}\\#{audio_filename}"
      end

      def osu_path
        "#{path}\\#{osu_filename}"
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

        @type = BeatmapType[ios.read_int 1]
        @circles, @sliders, @spinners = *ios.unpack(6, 'v*')
        @last_edit = ios.read_time
        # approach_rate(??) might be different from that in .osu
        @approach_rate, @circle_size, @hp_drain_rate, @overall_difficulty =
          *ios.unpack(4, 'C*')
        @slider_multiplier = ios.read_double
        # total_time = offset of last hit object
        @draining_time, @total_time, @preview_time = *ios.unpack(12, 'V*')
        # PreviewTime: -1
        @preview_time = nil if @preview_time == 0xFFFFFFFF

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
        @ratings        = ios.unpack(4, 'C*')
        @your_offset    = ios.read_signed_int 2
        @stack_leniency = ios.read_float
        @mode           = GameMode[ios.read_int 1]
        @source         = ios.read_str
        @tags           = ios.read_str
        @online_offset  = ios.read_signed_int 2

        # if letterbox_in_break?
        #   @letterbox = "[bold:0,size:20]%s\n%s" %
        #     [@title_unicode || @title, @artist_unicode || @artist]
        # else
        #   @letterbox = ''
        # end
        @letterbox = ios.read_str

        @played    = !ios.read_bool
        @last_play = ios.read_time
        # if !@played && @last_play != nil
        #   raise DBCorruptError, "played=%s doesn't match last_play=%s" %
        #     [@played, @last_play].map{|i| i.inspect}
        # end

        @zero1     = ios.read_int 1           # TODO: =0
        raise if @zero1 != 0
        @path      = ios.read_str
        @last_sync = ios.read_time

        @ignore_hitsound    = ios.read_bool
        @ignore_skin        = ios.read_bool
        @disable_storyboard = ios.read_bool
        @background_dim     = ios.read_int 1
        # @disable_video is not saved

        @zero2     = ios.read_int 1           # TODO: =0
        raise if @zero2 != 0
        @int1      = ios.read_int 4           # TODO: almost=0
        @int2      = ios.read_int 1           # TODO: almost=0, otherwise=7
        raise unless @int2 == 0 || @int2 == 7 # 0 iff original mode only
      end
    end
  end
end
