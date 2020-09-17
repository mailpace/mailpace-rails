$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "ohmysmtp-rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "ohmysmtp-rails"
  spec.version     = OhMySMTP::Rails::VERSION
  spec.authors     = ["OhMySMTP"]
  spec.email       = ["support@ohmysmtp.com"]
  spec.homepage    = "https://ohmysmtp.com"
  spec.summary     = "Lets you send transactional emails from your app over an easy to use API"
  spec.description = "The OhMySMTP Rails Gem is a plug in for ActionMailer to send emails via OhMySMTP to make sending emails from Rails apps super simple."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.0.2", ">= 6.0.2.2"

  spec.add_dependency('actionmailer', ">= 3.0.0")

  spec.add_dependency('httparty', '>= 0.18.1')

  spec.add_development_dependency('byebug')

  spec.add_development_dependency('pry')

  spec.add_development_dependency "sqlite3"
end
