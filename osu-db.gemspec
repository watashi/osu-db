# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'osu-db/version'

Gem::Specification.new do |gem|
  gem.name          = "osu-db"
  gem.version       = Osu::DB::VERSION
  gem.authors       = ["Zejun Wu"]
  gem.email         = ["zejun.wu@gmail.com"]
  gem.description   = %q{A tool to manipulate osu! beatmap and local scores database.}
  gem.summary       = %q{Library to manipulate osu! database}
  gem.homepage      = "https://github.com/watashi/osu-db"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
