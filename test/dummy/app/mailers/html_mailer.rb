class HtmlMailer < ApplicationMailer
  default from: 'notifications@example.com',
          to: 'fake@sdfasdfsdaf.com'

  def html_only_email
    mail
  end
end
