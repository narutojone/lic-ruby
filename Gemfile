source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# ruby '2.4.3'

# Core
gem 'rails',   '5.1.5'
gem 'pg',      '0.21.0'
gem 'puma',    '3.11.3'
gem 'sidekiq', '5.0.5'

# UI
gem 'turbolinks',   '5.1.0'
gem 'jquery-rails', '4.3.1'
gem 'sass-rails',   '~> 5.0'
gem 'uglifier',     '>= 1.3.0'
gem 'simple_form',  '3.5.0'

# Authentication and authorization
gem 'devise', '4.4.1'
gem 'pundit', '1.1.0'

# Misc
gem 'kaminari', '1.1.1'
gem 'ransack',  '1.8.4'
gem 'jbuilder', '2.7.0'
gem 'sanitize',       '4.5.0'
gem 'rails_autolink', '1.1.6'

# Monitoring & logging
gem 'rollbar',  '2.15.4'
gem 'lograge',  '0.9.0'

group :development, :test do
  gem 'byebug',       '>= 8.2.2'
  gem 'therubyracer', '>= 0.12.2'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'rspec-rails',       '3.7.2'
  gem 'factory_bot_rails', '4.8.2'
  gem 'capybara', '~> 2.13'
  gem 'capybara-screenshot'

  gem 'timecop', '>= 0.9.1'

  gem 'webmock', '>= 3.0.1'
  gem 'vcr',     '>= 3.0.1'

  gem 'poltergeist', '>= 1.15.0'
  gem 'simplecov', require: false
  gem 'database_cleaner'
  gem 'rails-controller-testing'
  gem 'faker'
end

gem 'will_paginate'
