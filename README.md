# Seedling

Seedling is a database-independent tool for dumping and loading seed data. It complements the `db:seed` rake task with loading/dumping data from/into YAML files. Provided data can be used to setup model attributes, properties and invoke methods with arguments. Exported data is saved to db/seed/dump/*.yml files, one per table.

This tool can be used as a replacement for mysqldump or pg_dump, but only for the ActiveRecord backed models. Users, permissions, schemas, triggers, and other advanced database features are not supported - by design.

Any database that has an ActiveRecord adapter should work.
This gem is Rails 3 only.

## Installation

Add this line to your application's Gemfile:

    gem 'seedling', :github => 'Sija/seedling'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install seedling

All rake tasks will then be available to you.

## Usage

    rake db:seed:dump[dir]  ->   Dump contents of ActiveRecord models to db/seed/dump/*.yml
    rake db:seed:load[dir]  ->   Seed the database with developments/ seeds.
    rake db:seed            ->   Seed the database with once/ and always/ seeds.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
