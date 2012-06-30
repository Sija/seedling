namespace :db do
  @seed_dir = File.join Rails.root, 'db', 'seed'

  def seed_dir(*args)
    File.join @seed_dir, *args
  end

  desc 'Seed the database with once/ and always/ seeds.'
  task :seed => :environment do
    Seedling.load_seeds seed_dir('once')
    Seedling.load_seeds seed_dir('always'), :always
  end

  namespace :seed do
    desc 'Seed the database with development/ seeds.'
    task :load, [:dir] => [:environment] do |t, args|
      args.with_defaults :dir => 'development'
      Seedling.load_seeds seed_dir(args[:dir]), :always
    end
    desc 'Dump contents of database to db/seed/dump/*.yml'
    task :dump, [:dir] => [:environment] do |t, args|
      args.with_defaults :dir => 'dump'
      Seedling.dump_seeds seed_dir(args[:dir])
    end
  end

  desc 'Dump schema and seeds to db/schema.rb and db/seed/dump/*.yml'
  task :dump => %w(db:schema:dump db:seed:dump)
end