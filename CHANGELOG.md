# 0.3.2

- Support for Rails 7.0.4.1, which uses Mail 2.8 under the hood
- Support full email address names (e.g. Name `<name@test.com>` in Bcc and Cc fields)
- Dependency upgrade

# 0.3.1

- Fix bug with ReplyTo attribute

# 0.3.0

- Dropped support for applications older than Rails 6
- Added ActionMailbox support for Inbound Emails
- Gem is now tested against a Rails 7 app by default

# 0.2.0

- List_Unsubscribe support
- Deliver function now returns API response