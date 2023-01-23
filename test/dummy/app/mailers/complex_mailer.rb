class ComplexMailer < ApplicationMailer
  default from: 'My Full Name <notifications@example.com>',
          cc: 'test@test.com, full name cc <test2@test.com>',
          bcc: 'full name bcc <test2@test.com>',
          to: 'fake@sdfasdfsdaf.com'

  def complex_email
    mail
  end
end
