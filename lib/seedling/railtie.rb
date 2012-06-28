require 'rails/railtie'

class Railtie < Rails::Railtie
  rake_tasks do
    load File.expand_path('../tasks/db.rake', __FILE__)
  end
end