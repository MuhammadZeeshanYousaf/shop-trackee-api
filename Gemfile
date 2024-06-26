source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.0.7"

# Use postgresql as the database for Active Record
gem "pg", "~> 1.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "~> 5.0"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
# gem "jbuilder"

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "~> 1.2"

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'dotenv-rails', require: 'dotenv/rails-now'
  gem 'rspec-rails', '~> 6.0.3'
  gem 'byebug', '~> 11.1', '>= 11.1.3'
end

group :development do
  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem 'rails-erd', '~> 1.7', '>= 1.7.2'
end

# My App Gems

gem "devise", "~> 4.9"
gem 'devise-api', github: 'nejdetkadir/devise-api', branch: 'main'
gem "aws-sdk-s3", require: false
gem 'aws-sdk-rekognition', '~> 1.86'
gem 'active_model_serializers', '~> 0.10.2'
gem 'array_enum', '~> 1.4'
gem 'cancancan', '~> 3.5'
gem "sentry-ruby"
gem "sentry-rails"
gem 'haversine', '~> 0.3.2'
gem 'mailjet', '~> 1.7', '>= 1.7.3'
gem 'kaminari', '~> 1.2', '>= 1.2.2'
