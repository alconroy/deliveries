source 'https://rubygems.org'
ruby "2.1.2"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.4'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.17.1'
# For SQLite instead
#gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails', '~> 3.1.0'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '2.2.2'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring', '1.1.3', group: :development


# For Heroku
gem 'rails_12factor', '0.0.2', group: :production

# Heroku's recommened web server
gem 'unicorn', '4.8.3'

# Extra timeout protection
gem 'rack-timeout', '0.0.4'

# Foundation 5
gem 'foundation-rails', '~> 5.3.1.0'

# Devise Authentication
gem 'devise', '3.2.4'

gem 'nokogiri', '1.6.3.1'

group :test, :development do
    # RSpec
  gem 'rspec-rails', '~> 3.0.2'
  # Needed for RSpec feature tests
  gem 'capybara', '2.4.1'
  # JS web driver, headless
  # need phantomjs - sudo apt-get install phantomjs
  gem 'poltergeist', '1.5.1'
  # Factory Girl fixtures
  gem 'factory_girl_rails', '4.4.1'
  # Fake test data
  gem 'faker', '1.4.2'
  # Jasmine JS Specs
  gem 'jasmine', '2.0.3'
end

group :test do
  # fake filesystem
  #gem "fakefs", :require => "fakefs/safe"
  # test coverage
  gem 'simplecov', '0.9.0', :require => false, :group => :test
  # for plotergeist test
  gem 'database_cleaner', '1.3.0', :group => :test
  # for failing screens
  #gem 'capybara-screenshot', :group => :test
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer',  platforms: :ruby
