require 'test_helper'
require 'mailpace/email_helper'

class MailpaceIngressTest < ActionDispatch::IntegrationTest
  test 'ingress has been set' do
    assert_equal :mailpace, ActionMailbox.ingress
  end

  test 'accept an email' do
    email = Email.new
    post email.url, params: email.params.to_json, headers: email.headers
    assert_response :success
    assert_equal ActionMailbox::InboundEmail.count, 1
  end
end
