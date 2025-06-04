source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Declare your gem's dependencies in mailpace-rails.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]

group :test do
  # Fix concurrent-ruby removing logger dependency in Rails 6 & 7.0
  gem 'concurrent-ruby', '<1.3.5' if ENV['RAILS_TEST_VERSION']&.start_with?('7.') || ENV['RAILS_TEST_VERSION']&.start_with?('6.')
  gem 'sprockets-rails'
  gem 'sqlite3', '~> 1.4'if ENV['RAILS_TEST_VERSION']&.start_with?('7.') || ENV['RAILS_TEST_VERSION']&.start_with?('6.')
  gem 'webmock'
end
