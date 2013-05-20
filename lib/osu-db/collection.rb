require 'forwardable'
require 'osu-db/common'

module Osu
  module DB
=begin rdoc
== Structure of collection.db
* *str*[rdoc-ref:StringIO#read_str] #name: collection name
* *int*[rdoc-ref:StringIO#read_int] number of beatmaps in this collection
* *str*[rdoc-ref:StringIO#read_str] #beatmaps: Array of digests of beatmaps
=end
    class Collection
      include Enumerable
      extend Forwardable

      def_delegators :beatmaps, :each

      attr_reader :name, :beatmaps

      def initialize(ios = nil)
        load(ios) if ios
      end

      def load(ios)
        @name = ios.read_str
        n = ios.read_int 4
        @beatmaps = Array.new(n) do
          ios.read_str
        end
      end
    end
  end
end
