require 'stringio'

module Osu
  module DB
    class UnsupportedVersionError < RuntimeError
    end

    class DBCorruptError < RuntimeError
    end


    class StringIO < ::StringIO
      def unpack(bytesize, format)
        read(bytesize).unpack(format)
      end

      def readint(bytesize)
        unpack(bytesize, "C#{bytesize}").reverse.inject{|h, l| h << 8 | l}
      end

      def readstr
        tag = read(1)
        if tag != "\x0b"
          raise DBCorruptError, "0x0b expected, got #{'0x%02x' % tag.ord}"
        else
          len = readint(1)
          read(len)
        end
      end

      VERSION_MIN = "\x89\x06\x33\x01".unpack('V')[0]
      VERSION_MAX = "\x8D\x06\x33\x01".unpack('V')[0]

      def version!
        version = readint(4)
        unless (VERSION_MIN .. VERSION_MAX).include? version
          raise UnsupportedVersionError, "version = #{'0x%08x' % version}"
        end
      end
    end
  end
end
