require 'globalize3'

module SpreeI18n
  class Engine < Rails::Engine
    engine_name 'spree_i18n'

    config.autoload_paths += %W(#{config.root}/lib)

    initializer 'spree-i18n' do |app|
      SpreeI18n::Engine.instance_eval do
        pattern = pattern_from app.config.i18n.available_locales

        add("config/locales/#{pattern}/*.{rb,yml}")
        add("config/locales/#{pattern}.{rb,yml}")
      end
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), "../../app/**/*_decorator*.rb")) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc

    protected
    def self.add(pattern)
      files = Dir[File.join(File.dirname(__FILE__), '../..', pattern)]
      I18n.load_path.concat(files)
    end

    def self.pattern_from(args)
      array = Array(args || [])
      array.blank? ? '*' : "{#{array.join ','}}"
    end
  end
end