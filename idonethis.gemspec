# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'idonethis/version'

Gem::Specification.new do |gem|
  gem.name          = "idonethis"
  gem.version       = Idonethis::VERSION
  gem.authors       = ["Ryan Brunner"]
  gem.email         = ["ryan@ryanbrunner.com"]
  gem.description   = %q{Simple little command line tool for sending idonethis messages}
  gem.summary       = %q{Sends messages to your idonethis using the e-mail client of your choice (as long as your choice is gmail)}
  gem.homepage      = "http://github.com/influitive/idonethis"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  %w( ruby-gmail activesupport hashie mime syck ).each do |g|
    gem.add_runtime_dependency g
  done
end
