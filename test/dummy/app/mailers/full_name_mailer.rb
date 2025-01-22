class FullNameMailer < ApplicationMailer
  default from: 'My Full Name <notifications@example.com>',
          to: 'Recipient Full Name <fake@sdfasdfsdaf.com>'

  def full_name_email
    mail
  end
end
