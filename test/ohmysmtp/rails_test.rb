require 'test_helper'
require 'pry'

class OhMySMTP::Rails::Test < ActiveSupport::TestCase
  setup do
    ActionMailer::Base::delivery_method = :ohmysmtp
    ActionMailer::Base.ohmysmtp_settings = { api_token: 'api_token' }
  end

  test 'truth' do
    assert_kind_of Module, OhMySMTP::Rails
  end

  test 'api token can be set' do
    ActionMailer::Base.ohmysmtp_settings = { api_token: 'api-token' }
    assert_equal ActionMailer::Base.ohmysmtp_settings[:api_token], 'api-token'
  end

  test 'raises RuntimeError when trying to send emails to real endpoint' do
    t = TestMailer.welcome_email
    # This will trigger the real endpoint and fail with an API token error
    # TODO: mock API endpoint
    assert_raise(RuntimeError) { t.deliver! }
  end

  test 'raises ArgumentError if no api token set' do
    ActionMailer::Base.ohmysmtp_settings = { }
    t = TestMailer.welcome_email
    assert_raise(ArgumentError) { t.deliver! }
  end

  test 'raises ArgumentError if no from address in email' do
    t = TestMailer.welcome_email
    t.from = nil
    assert_raise(ArgumentError) { t.deliver! }
  end

  test 'raises ArgumentError if no to address in email' do
    t = TestMailer.welcome_email
    t.to = nil
    assert_raise(ArgumentError) { t.deliver! }
  end

  # TODO: Test complex emails with replyto, bcc, cc, subject, from, to etc.
end
