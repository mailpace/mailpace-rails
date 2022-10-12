$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "mailpace-rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "mailpace-rails"
  spec.version     = Mailpace::Rails::VERSION
  spec.authors     = ["MailPace"]
  spec.email       = ["support@mailpace.com"]
  spec.homepage    = "https://mailpace.com"
  spec.summary     = "Lets you send transactional emails from your app over an easy to use API"
  spec.description = "The MailPace Rails Gem is a plug in for ActionMailer to send emails via MailPace to make sending emails from Rails apps super simple."
  spec.license     = "MIT"

  spec.metadata['source_code_uri'] = 'https://github.com/mailpace/mailpace-rails'
  spec.metadata['changelog_uri'] = 'https://github.com/mailpace/mailpace-rails/blob/master/CHANGELOG.md'

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency('actionmailer', ">= 6.0.0")
  spec.add_dependency('httparty', '>= 0.18.1')

  spec.add_development_dependency "rails", "#{ENV['RAILS_TEST_VERSION'] || '>=6.1.4.1'}"
  spec.add_development_dependency "sqlite3", ">=1.4.2"
end
