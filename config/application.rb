require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RailsHeroku
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # App specific settings
    config.deliveries = {
        # The name of company, appears as page titles
        :company_name => 'Thirty Nine',

        # The location 'latitude, longitude' of the companies base,
        # i.e. the start/end point of route.
        #:home_location => '53.7843,-1.5020', # Industrial Estate in Leeds
        :home_location => '53.317,-6.370', # Red Cow, Naas Rd, Dublin

        # The API key for Bing Maps queries
        #   http://msdn.microsoft.com/en-us/library/ff428642.aspx
        #   https://www.bingmapsportal.com/
        :bing_maps_key => 'AgUpD8p1gYE25hd1f0NnVt6hu_Y8wNDx37h8rY09UqLpQlNnjFMTs-IZgdYraiuq'
    }

  end
end
