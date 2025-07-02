require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Sinsems
	class Application < Rails::Application
        # Settings in config/environments/* take precedence over those specified here.
        # Application configuration should go into files in config/initializers
        # -- all .rb files in that directory are automatically loaded.
        config.time_zone = 'Santiago'
        config.i18n.default_locale = "pt-BR"

        # Do not fallback to assets pipeline if a precompiled asset is missed.
        config.assets.compile = true
        config.assets.enabled = true
        config.assets.paths << Rails.root.join("app", "assets", "fonts")
    end
end
