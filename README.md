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

Load datebase

    require 'osu-db'

    beatmapdb = Osu::DB::BeatmapDB.new
    beatmapdb.load(IO.read('osu!.db'))

    scoredb = Osu::DB::ScoreDB.new
    scoredb.load(IO.read('scores.db'))

Let's have fun with touhou music

    beatmapdb.select{|i| i.source =~ /touhou/i}.shuffle.each do |i|
      puts "#{i.artist_unicode || i.artist} - #{i.title_unicode || i.title}"
      `mplayer "#{i.audio_path}" 2>&1 >/dev/null`
    end

Calculate the average accuracy

    scores = scoredb.select{|i| i.game_mode == :osu!}
    p scores.inject(0){|i, j| i + j.accuracy} / scores.size

Print all taiko scores

    beatmaps = beatmapdb.select{|i| i.mode == :Taiko}.map(&:beatmapcode)
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
