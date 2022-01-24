# frozen_string_literal: true

class Email
  def initialize(mail: default_mail)
    @mail = mail
  end

  def headers
    {
      'content-type': 'application/json',
      Authorization: ActionController::HttpAuthentication::Basic.encode_credentials('actionmailbox', 'test')
    }
  end

  def url
    '/rails/action_mailbox/mailpace/inbound_emails'
  end

  def params
    {
      raw: @mail.encoded,
      test: 'test'
    }
  end

  def default_mail
    Mail.new
  end
end
