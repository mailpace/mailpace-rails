class FullNameMailer < ApplicationMailer
  default from: 'My Full Name <notifications@example.com>',
          to: 'fake@sdfasdfsdaf.com'

  def full_name_email
    mail
  end
end
