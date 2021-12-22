# OhMySMTP::Rails

[![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)](https://opensource.org/licenses/MIT)
[![Gem Version](https://badge.fury.io/rb/ohmysmtp-rails.svg)](https://badge.fury.io/rb/ohmysmtp-rails)
[![OhMySMTP Rails](https://circleci.com/gh/ohmysmtp/ohmysmtp-rails.svg?style=svg)](https://app.circleci.com/pipelines/github/ohmysmtp/ohmysmtp-rails)

[OhMySMTP](https://ohmysmtp.com) lets you send transactional emails from your app over an easy to use API.

The OhMySMTP Rails Gem is a plug in for ActionMailer to send emails via [OhMySMTP](https://ohmysmtp.com) to make sending emails from Rails apps super simple.

> **New in 0.3.0: The ability to consume [inbound emails](https://docs.ohmysmtp.com/guide/inbound/) from OhMySMTP via ActionMailbox**

##  Usage

Once installed and configured, continue to send emails using [ActionMailer](https://guides.rubyonrails.org/action_mailer_basics.html) and receive emails with [ActionMailbox](https://edgeguides.rubyonrails.org/action_mailbox_basics.html) like normal.

## Other Requirements

You will need an OhMySMTP account with a verified domain and organization with an active plan.

## Installation

### Account Setup 

Set up an account at [OhMySMTP](https://app.ohmysmtp.com/users/sign_up) and complete the Onboarding steps

### Gem Installation

Add this line to your application's Gemfile:

```ruby
gem 'ohmysmtp-rails'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install ohmysmtp-rails
```

### Configure the Gem

First you will need to retrieve your API token for your sending domain from [OhMySMTP](https://app.ohmysmtp.com). You can find it under Organization -> Domain -> API Tokens.

Use the encrypted secret management to save your API Token to `config/credentials.yml.enc` by running the following:

```bash
rails secret
rails credentials:edit
```

Then add your token:

```yaml
ohmysmtp_api_token: "TOKEN_GOES_HERE"
```

Set OhMySMTP as your mail delivery method in `config/application.rb`:

```ruby
config.action_mailer.delivery_method = :ohmysmtp
config.action_mailer.ohmysmtp_settings = { api_token: Rails.application.credentials.ohmysmtp_api_token }
```

## Tagging

You can tag messages and filter them later in the OhMySMTP UI. To do this, pass the tags as a header by adding a tag variable to your `mail` method call.

```ruby
class TestMailer < ApplicationMailer
  default from: 'notifications@example.com',
          to: 'fake@sdfasdfsdaf.com'

  def single_tag
    mail(
      tags: 'test tag' # One tag
    )
  end

  def multi_tag
    mail(
      tags: "['test tag', 'another-tag']" # Multiple tags
    )
  end
end
```

Note that this should always be a string, even if using an array of multiple tags.

## List-Unsubscribe

To add a List-Unsubscribe header, pass a `list_unsubscribe` string to the `mail` function:

```ruby
class TestMailer < ApplicationMailer
  default from: 'notifications@example.com',
          to: 'fake@sdfasdfsdaf.com'

  def list_unsub_header
    mail(
      list_unsubscribe: 'https://listunsublink.com'
    )
  end
end
```

## ActionMailbox setup (for receiving inbound emails)

As of v0.3.0, this Gem supports handling Inbound Emails (see https://docs.ohmysmtp.com/guide/inbound/ for details) via ActionMailbox. To setup:

1. Tell Action Mailbox to accept emails from OhMySMTP in config/environments/production.rb

```ruby
config.action_mailbox.ingress = :ohmysmtp
```

2. Generate a strong password that Action Mailbox can use to authenticate requests to the OhMySMTP ingress.
Use `bin/rails credentials:edit` to add the password to your application's encrypted credentials under `action_mailbox.ingress_password`, where Action Mailbox will automatically find it:

```yaml
action_mailbox:
  ingress_password: ...
```

Alternatively, provide the password in the `RAILS_INBOUND_EMAIL_PASSWORD` environment variable.

3. Configure OhMySMTP see [inbound docs](https://docs.ohmysmtp.com/guide/inbound) to forward inbound emails
to `/rails/action_mailbox/ohmysmtp/inbound_emails` with the username `actionmailbox` and the password you previously generated. If your application lived at `https://example.com` you would configure your OhMySMTP inbound endpoint URL with the following fully-qualified URL:

`https://actionmailbox:PASSWORD@example.com/rails/action_mailbox/ohmysmtp/inbound_emails`
## Support

For support please check the [OhMySMTP Documentation](https://docs.ohmysmtp.com)  or contact us at support@ohmysmtp.com

## Contributing

Please ensure to add a test for any change you make. To run the tests:

`bin/test`

Pull requests always welcome

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
