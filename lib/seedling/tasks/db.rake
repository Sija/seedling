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
    task :dev, [:dir] => [:environment] do |t, args|
      args.with_defaults :dir => 'development'
      Seedling.load_seeds seed_dir(args[:dir]), :always
    end
  end

  desc 'Dump schema and data to db/schema.rb and db/seed/dump/*.yml'
  task :dump => ['db:schema:dump', 'db:data:dump']

  namespace :data do
    desc 'Dump contents of database to db/seed/dump/*.yml'
    task :dump, [:dir] => [:environment] do |t, args|
      args.with_defaults :dir => 'dump'
      Seedling.dump_seeds seed_dir(args[:dir])
    end
  end
end