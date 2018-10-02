source "https://rubygems.org"

ruby "2.3.7"

git_source(:github) do |repo_name|
  "https://github.com/#{repo_name}.git"
end

gem "activeadmin", github: "activeadmin/activeadmin"
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
gem "neat", "~> 1.9"
gem "newrelic_rpm"
gem "normalize-rails"
gem "omniauth"
gem "omniauth-github-team-member"
gem "omniauth-oauth2"
gem "pg"
gem "puma"
gem "rack-timeout"
gem "rails", "~> 4.2"
gem "rake", "~> 11"
gem "recipient_interceptor"
gem "sass-rails"
gem "time_for_a_boolean"
gem "title"
gem "uglifier"

group :development do
  gem "bundler-audit"
end

group :development, :test do
  gem "byebug"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "pry-rails"
  gem "rspec-rails"
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
