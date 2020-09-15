require 'pry'

class TestMailer < ApplicationMailer
  default from: 'notifications@example.com'
 
  def welcome_email
    mail
  end
end
