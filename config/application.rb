require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module TrackMyShopApi
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    config.time_zone = 'Asia/Karachi'
    # config.eager_load_paths << Rails.root.join("extras")

    # Handle cancancan exception CanCan::AccessDenied
    config.action_dispatch.rescue_responses.merge!('CanCan::AccessDenied' => :unauthorized)

    # customize rails generator workflow
    config.generators do |g|
      g.test_framework :rspec
    end

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    # set default url host for url helpers in mailer views
    config.action_mailer.default_url_options = { host: ENV.fetch('HOST_URL') { "http://localhost:#{ENV['PORT'] || 3000}" }  }

    # set default image pre processor
    config.active_storage.variant_processor = :vips
  end
end

# set default url option to generate urls using url helpers
Rails.application.routes.default_url_options[:host] = ENV.fetch('HOST_URL') { "http://localhost:#{ENV['PORT'] || 3000}" }
