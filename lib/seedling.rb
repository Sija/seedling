require 'yaml'
require 'seedling/version'
require 'seedling/railtie'

module Seedling
  def self.load_seeds(dir, always = false)
    raise "Seed directory #{dir} doesn't exists!" unless File.exists? dir
    
    connection.transaction do
      Dir.glob(File.join(dir, '*.yml')).each do |seed_file|
        table_name = File.basename(seed_file, '.yml')
        
        if always || table_empty?(table_name)
          load_table seed_file, table_name
        end
      end
    end
  end

  def self.load_table(seed_file, table_name)
    unless model_class = table_to_model(table_name)
      raise "No corresponding model found for #{table_name} table"
    end
    seeds = File.read seed_file
    seeds = YAML.load_documents seeds
    seeds.flatten!
    
    connection.transaction(:requires_new => true) do
      model_class.delete_all
      connection.reset_pk_sequence! table_name
      
      if defined?(::Paperclip) and model_class.attachment_definitions
        paperclip_fields = model_class.attachment_definitions.keys.map(&:to_s)
      end
      if defined?(::Dragonfly) and model_class.dragonfly_apps_for_attributes
        dragonfly_fields = model_class.dragonfly_apps_for_attributes.keys.map(&:to_s)
      end
      
      seeds.each do |seed|
        files = seed.delete(:files) || {}
        options = seed.delete(:options) || {}
        calls = seed.delete(:invoke) || []
        attributes = seed.delete(:attributes) || {}
        properties = seed.delete(:properties) || {}
        properties.merge! seed
        
        model = model_class.new attributes, options
        properties.each do |key, value|
          model[key] = value
        end
        files.each do |key, filename|
          path = File.join File.dirname(seed_file), table_name, filename
          case
          when key.in?(paperclip_fields || [])
            model.send "#{key}=", File.open(path)
          when key.in?(dragonfly_fields || [])
            model.send "#{key}=", File.read(path)
          else
            raise "#{model} doesn't know how to handle file attribute '#{key}'"
          end
        end
        calls.each do |call|
          method, args = Array.wrap call
          unless model.respond_to? method
            raise "#{model} doesn't seem to respond to '#{method}' method!"
          end
          model.send method, *args
        end
        unless model.save
          raise "Validation for #{model} failed: #{model.errors.to_a.to_sentence}"
        end
      end
    end
  end

  def self.dump_seeds(dir)
    ar_models.each do |model_class|
      dump_table dir, model_class.table_name if model_class.any?
    end
  end

  def self.dump_table(dir, table_name)
    unless model_class = table_to_model(table_name)
      puts "No corresponding model found for #{table_name} table"
      return
    end
    records = model_class.all.map(&:attributes)
    records.each do |record|
      record.reject! { |key| key =~ /^(updated|created)_(on|at)$/ }
      record.reject! { |key, value| value.blank? }
    end
    FileUtils.mkdir_p dir
    filename = "#{File.join dir, table_name}.yml"
    File.open(filename, 'w') do |file|
      file.write records.to_yaml
    end
  end

  def self.ar_models
    unless @ar_models
      Dir["#{Rails.root}/app/models/**/*.rb"].each { |f| require f }
      @ar_models = ActiveRecord::Base.send :descendants
    end
    @ar_models
  end

  def self.table_to_model(table_name)
    ar_models.detect { |m| m.table_name == table_name }
  end

  def self.table_empty?(table_name)
    quoted = connection.quote_table_name(table_name)
    connection.select_value("SELECT COUNT(*) FROM #{quoted}").to_i.zero?
  end

  def self.tables
    connection.tables.reject { |table| table =~ /^schema_/ }
  end

  def self.connection
    ActiveRecord::Base.connection
  end
end
