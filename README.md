# Osu::DB

A tool to manipulate osu! beatmap and local scores database.

## Installation

Add this line to your application's Gemfile:

    gem 'osu-db'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install osu-db

## Usage

    require 'osu-db'

    beatmapdb = Osu::DB::BeatmapDB.new
    beatmapdb.load(IO.read('osu!.db'))
    beatmaps = beatmapdb.select{|i| i.mode == :CatchTheBeat}.map{|i| i.beatmapcode}

    scoredb = Osu::DB::ScoreDB.new
    scoredb.load(IO.read('scores.db'))
    scores = scoredb.select{|i| beatmaps.include? i.beatmapcode}

    scores.sort{|i, j| i.datetime <=> j.datetime}.each do |i|
      puts "%10s %7d %3d  %s" % [i.user, i.score, i.combo, i.mods]
    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
