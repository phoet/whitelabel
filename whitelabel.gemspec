# -*- encoding: utf-8 -*-
require File.expand_path('../lib/whitelabel/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Peter Schröder"]
  gem.email         = ["phoetmail@googlemail.com"]
  gem.description = gem.summary = %q{This gem helps you providing whitelabel functionality in your application}
  gem.homepage      = "https://github.com/phoet/whitelabel"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "whitelabel"
  gem.require_paths = ["lib"]
  gem.version       = Whitelabel::VERSION

  gem.add_development_dependency('rspec', '~> 3.1')
  gem.add_development_dependency('pry', '~> 0.10')
  gem.add_development_dependency('rake', '~> 10.4')
end
