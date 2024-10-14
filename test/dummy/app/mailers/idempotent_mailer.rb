class IdempotentMailer < ApplicationMailer
  default from: 'notifications@example.com',
          to: 'fake@sdfasdfsdaf.com'

  def idempotent_email
    mail(
      idempotency_key: 'example key'
    )
  end
end
