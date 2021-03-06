require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    config.load_defaults 5.1

    config.eager_load_paths << Rails.root.join('lib')
    config.middleware.use ActionDispatch::Flash
    config.api_only = false
  end
end
