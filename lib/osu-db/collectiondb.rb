require 'forwardable'
require 'osu-db/common'
require 'osu-db/collection'

module Osu
  module DB
    class CollectionDB
      include Enumerable
      extend Forwardable

      def_delegators :collections, :each

      attr_reader :collections

      def load(str)
        ios = StringIO.new(str, 'rb')
        ios.read_version

        n = ios.read_int 4
        @collections = Array.new(n) do
          Collection.new(ios)
        end
      end
    end
  end
end
