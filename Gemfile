source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.4'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# jquery autocomplete for search bar
gem 'jquery-ui-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'mailgun-ruby', '~>1.0.2', require: 'mailgun'
gem 'mailgun_rails'

gem 'geocoder'

gem 'yelp', require: 'yelp'

gem 'gmaps4rails', git: 'https://github.com/fiedl/Google-Maps-for-Rails.git'
# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
gem 'bootstrap-sass', '~> 3.2.0'
# Use Haml as the templating library
gem 'haml'
gem 'carrierwave', '~> 0.11.0'
# Use Unicorn as the app server
# gem 'unicorn'
gem 'selenium-webdriver'
gem 'private_pub'
gem 'thin'
gem 'faye'
gem 'fog-aws'
gem 'fog'
gem 'aws-sdk', '~> 2'
# Use Capistrano for deploymt
# gem 'capistrano-rails', group: :development
gem 'factory_girl_rails'
group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'sqlite3'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'simplecov', :require => false
end

group :test do
  gem 'launchy'
  gem 'rspec-expectations'
  gem 'cucumber-rails', :require=>false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :production do
  gem 'pg' # for Heroku deployment
  gem 'rails_12factor'
end
