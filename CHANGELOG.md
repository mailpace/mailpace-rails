# 0.4.2

- Send text-only if not multipart and content-type is text/plain (thanks [@zachasme](https://github.com/zachasme))
- Support full names in To / Reply To addresses (thanks [@lazyatom](https://github.com/lazyatom))
- Support multiple reply to addresses (thanks [@lazyatom](https://github.com/lazyatom))
- CI now tests against latest versions of Rails (8.0.2) and Ruby (3.4.4)

# 0.4.1

- Fix bug where Idempotent Key is set to '', when not set

# 0.4.0

- Add support for `InReplyTo` and `References` headers
- Now raises a `Mailpace::DeliveryError` on failure (thanks to [@dpaluy](https://github.com/dpaluy))
- Idempotent Requests (https://docs.mailpace.com/guide/idempotency/)
- Now tested against Rails 7.2, 8.0.0 and Ruby 3.2
- Declares a dependency on actionmailbox and activestorage (resolves https://github.com/mailpace/mailpace-rails/issues/27) 

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
