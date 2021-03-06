# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'idonethis/version'

Gem::Specification.new do |gem|
  gem.name          = 'idonethis'
  gem.version       = Idonethis::VERSION
  gem.authors       = ['Ryan Brunner', 'Chad Barraford']
  gem.email         = ['ryan@ryanbrunner.com', 'cbarraford@gmail.com']
  gem.description   = %q(Simple little command line tool for sending idonethis messages)
  gem.summary       = 'Sends messages to your idonethis using the e-mail client of your ' \
                      'choice (as long as your choice is gmail)'
  gem.homepage      = 'http://github.com/influitive/idonethis'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(/^bin/).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(/^(test|spec|features)/)
  gem.require_paths = ['lib']

  %w( ruby-gmail activesupport hashie mime syck thor colorize ).each do |g|
    gem.add_runtime_dependency g
  end

  %w( rake rubocop ).each do |g|
    gem.add_development_dependency g
  end
end
