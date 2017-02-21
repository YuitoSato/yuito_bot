require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module YuitoBot
  class Application < Rails::Application
    config.autoload_paths += Dir["#{config.root}/app/services"]
    config.generators do |g|
      g.assets  false
      g.helper  false
    end
  end
end
