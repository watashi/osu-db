module Osu
  module DB
    class TimingPoint
      private_class_method :new

      attr_reader :offset, :bpm

      def initialize(offset, bmp)
        @offset = offset
        @bpm = bmp
      end
    end

    class RegularTimingPoint < TimingPoint
      public_class_method :new
    end

    class InheritedTimingPoint < TimingPoint
      public_class_method :new
    end
  end
end
