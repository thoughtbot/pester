source "https://rubygems.org"

ruby "2.3.7"

gem "activeadmin", github: "activeadmin"
gem "awesome_print"
gem "bourbon"
gem "coffee-rails"
gem "delayed_job_active_record"
gem "email_validator"
gem "flutie"
gem "high_voltage"
gem "honeybadger"
gem "i18n-tasks"
gem "jquery-rails"
gem "neat", "~> 1.7.0"
gem "newrelic_rpm"
gem "normalize-rails", "~> 3.0.0"
gem "omniauth"
gem "omniauth-github-team-member"
gem "omniauth-oauth2", "~> 1.3.1"
gem "pg"
gem "rack-timeout"
gem "rake", "~> 11"
gem "rails", "~> 4.2"
gem "recipient_interceptor"
gem "sass-rails"
gem "time_for_a_boolean"
gem "title"
gem "uglifier"
gem "unicorn"

group :development do
  gem "bundler-audit"
  gem "spring"
  gem "spring-commands-rspec"
end

group :development, :test do
  gem "byebug"
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "pry-rails"
  gem "rspec-rails", "~> 3.0"
end

group :test do
  gem "capybara-selenium"
  gem "chromedriver-helper"
  gem "database_cleaner"
  gem "formulaic"
  gem "launchy"
  gem "rspec_junit_formatter"
  gem "shoulda-matchers"
  gem "timecop"
  gem "webmock"
end

group :staging, :production do
  gem "rails_12factor"
end
