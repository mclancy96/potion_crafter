# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.3.5"

gem "bcrypt"
gem "bootsnap", require: false
gem "importmap-rails"
gem "jbuilder"
gem "propshaft"
gem "puma", ">= 5.0"
gem "rails", "~> 8.0.2", ">= 8.0.2.1"
gem "solid_cable"
gem "solid_cache"
gem "solid_queue"
gem "sqlite3", ">= 2.1"
gem "stimulus-rails"
gem "thruster", require: false
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[windows jruby]

group :development, :test do
  gem "brakeman", require: false
  gem "pry"
  gem "rubocop", require: false
  gem "rubocop-performance", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "factory_bot_rails"
  gem "rspec"
  gem "rspec-rails", "~> 8.0"
  gem "selenium-webdriver"
  gem "shoulda-matchers", "~> 5.0"
end
