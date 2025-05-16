class PlaintextMailer < ApplicationMailer
  default from: 'notifications@example.com',
          to: 'fake@sdfasdfsdaf.com'

  def plain_only_email
    mail
  end
end
