# -*- encoding: utf-8 -*-
require File.expand_path('../lib/seedling/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Sijawusz Pur Rahnama']
  gem.email         = ['sija@sija.pl']
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{Seedling allows import/export of database seeds from/into yaml files}
  gem.homepage      = 'https://github.com/Sija/seedling'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'seedling'
  gem.require_paths = ['lib']
  gem.version       = Seedling::VERSION

  gem.add_dependency 'rails', '~> 3'
  gem.add_dependency 'activerecord', '~> 3'
end
