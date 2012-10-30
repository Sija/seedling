# -*- encoding: utf-8 -*-
require File.expand_path('../lib/seedling/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ['Sijawusz Pur Rahnama']
  gem.email         = ['sija@sija.pl']
  gem.summary       = 'Seedling allows import/export of database seeds from/into yaml files'
  gem.homepage      = 'https://github.com/Sija/seedling'
  gem.description   = %q(
    Seedling is a database-independent tool for dumping and loading seed data. It complements the `db:seed` rake task with loading/dumping data from/into YAML files. Provided data can be used to setup model attributes, properties and invoke methods with arguments. Exported data is saved to db/seed/dump/*.yml files, one per table.

    This tool can be used as a replacement for mysqldump or pg_dump, but only for the ActiveRecord backed models. Users, permissions, schemas, triggers, and other advanced database features are not supported - by design.

    Any database that has an ActiveRecord adapter should work.
    This gem is Rails 3 only.
  )
  
  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = 'seedling'
  gem.require_paths = ['lib']
  gem.version       = Seedling::VERSION

  gem.add_dependency 'railties', '~> 3'
  gem.add_dependency 'activerecord', '~> 3'
end
