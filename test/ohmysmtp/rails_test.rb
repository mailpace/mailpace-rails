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

  test 'raises exception when trying to send emails' do
    t = TestMailer.welcome_email
    assert_raise(RuntimeError) { t.deliver! }
  end

  test 'raises exception if no api token set' do
    ActionMailer::Base.ohmysmtp_settings = { }
    t = TestMailer.welcome_email
    assert_raise(ArgumentError) { t.deliver! }
  end

  test 'raises exception if no from address in email' do
    t = TestMailer.welcome_email

    binding.pry
    assert_raise(ArgumentError) { t.deliver! }
  end

end
