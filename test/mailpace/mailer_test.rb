require 'test_helper'

class Mailpace::Rails::Test < ActiveSupport::TestCase
  setup do
    ActionMailer::Base.delivery_method = :mailpace
    ActionMailer::Base.mailpace_settings = { api_token: 'api_token' }

    stub_request(:post, 'https://app.mailpace.com/api/v1/send')
      .to_return(
        body: { "status": 'queued', "id": 1 }.to_json,
        headers: { content_type: 'application/json' },
        status: 200
      )

    @test_email = TestMailer.welcome_email
  end

  test 'truth' do
    assert_kind_of Module, Mailpace::Rails
  end

  test 'api token can be set' do
    ActionMailer::Base.mailpace_settings = { api_token: 'api-token' }
    assert_equal ActionMailer::Base.mailpace_settings[:api_token], 'api-token'
  end

  test 'raises ArgumentError if no api token set' do
    ActionMailer::Base.mailpace_settings = {}
    assert_raise(ArgumentError) { @test_email.deliver! }
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

  test 'send basic emails to endpoint' do
    @test_email.deliver!
  end

  test 'supports multiple attachments' do
    t = TestMailer.welcome_email
    t.attachments['logo.png'] = File.read("#{Dir.pwd}/test/logo.png")
    t.attachments['l2.png'] = File.read("#{Dir.pwd}/test/logo.png")

    t.deliver!

    assert_requested(
      :post, 'https://app.mailpace.com/api/v1/send',
      times: 1
    ) do |req|
      attachments = JSON.parse(req.body)['attachments']
      attachments[0]['name'] == 'logo.png' && attachments[1]['name'] == 'l2.png'
    end
  end

  test 'supports custom mime types' do
    t = TestMailer.welcome_email
    t.attachments['logo.png'] = {
      mime_type: 'custom/type',
      content: File.read("#{Dir.pwd}/test/logo.png")
    }
    t.deliver!

    assert_requested(
      :post, 'https://app.mailpace.com/api/v1/send',
      times: 1
    ) do |req|
      JSON.parse(req.body)['attachments'][0]['content_type'] == 'custom/type'
    end
  end

  test 'supports full names in the from address' do
    t = FullNameMailer.full_name_email
    t.deliver!

    assert_requested(
      :post, 'https://app.mailpace.com/api/v1/send',
      times: 1
    ) do |req|
      JSON.parse(req.body)['from'] == 'My Full Name <notifications@example.com>'
    end
  end

  test 'supports single tag' do
    t = TagMailer.single_tag
    t.deliver!

    assert_requested(
      :post, 'https://app.mailpace.com/api/v1/send',
      times: 1
    ) do |req|
      JSON.parse(req.body)['tags'] == 'test tag'
    end
  end

  test 'supports array of tags tag' do
    t = TagMailer.multi_tag
    t.deliver!

    assert_requested(
      :post, 'https://app.mailpace.com/api/v1/send',
      times: 1
    ) do |req|
      JSON.parse(req.body)['tags'] == "['test tag', 'another-tag']"
    end
  end

  test 'does not send tags if tags not supplied' do
    t = TestMailer.welcome_email
    t.deliver!

    assert_requested(
      :post, 'https://app.mailpace.com/api/v1/send',
      times: 1
    ) do |req|
      JSON.parse(req.body)['tags'].nil?
    end
  end

  test 'supports List-Unsubscribe header' do
    t = ListUnsubscribeMailer.unsubscribe
    t.deliver!

    assert_requested(
      :post, 'https://app.mailpace.com/api/v1/send',
      times: 1
    ) do |req|
      JSON.parse(req.body)['list_unsubscribe'] == 'test list-unsubscribe'
    end
  end

  test 'deliver! returns the API response' do
    t = TestMailer.welcome_email
    res = t.deliver!
    assert_equal res['id'], 1
  end

  # See https://github.com/mikel/mail/blob/22a7afc23f253319965bf9228a0a430eec94e06d/lib/mail/fields/reply_to_field.rb
  test 'supports reply to' do
    t = TestMailer.welcome_email
    t.reply_to = 'This will be stripped <reply@test.com>'
    t.deliver!

    assert_requested(
      :post, 'https://app.mailpace.com/api/v1/send',
      times: 1
    ) do |req|
      JSON.parse(req.body)['replyto'] == 'reply@test.com'
    end
  end

  test 'supports complex cc and bcc entries' do
    t = ComplexMailer.complex_email
    t.deliver!

    assert_requested(
      :post, 'https://app.mailpace.com/api/v1/send',
      times: 1
    ) do |req|
      JSON.parse(req.body)['cc'] == 'test@test.com,full name cc <test2@test.com>' &&
        JSON.parse(req.body)['bcc'] == 'full name bcc <test2@test.com>'
    end
  end

  test 'raises DeliveryError if response is not 200' do
    stub_request(:post, 'https://app.mailpace.com/api/v1/send')
      .to_return(
        body: { error: 'contains a blocked address' }.to_json,
        headers: { content_type: 'application/json' },
        status: 400
      )

    t = TestMailer.welcome_email

    assert_raise(Mailpace::DeliveryError, 'MAILPACE Error: contains a blocked address') do
      t.deliver!

    end
  end

  test 'supports in-reply-to' do
    t = TestMailer.welcome_email
    t.in_reply_to = '<message-id@test.com>'
    t.deliver!

    assert_requested(
      :post, 'https://app.mailpace.com/api/v1/send',
      times: 1
    ) do |req|
      JSON.parse(req.body)['inreplyto'] == '<message-id@test.com>'
    end
  end

  test 'supports single references' do
    t = TestMailer.welcome_email
    t.references = '<message-id@test.com>'
    t.deliver!

    assert_requested(
      :post, 'https://app.mailpace.com/api/v1/send',
      times: 1
    ) do |req|
      JSON.parse(req.body)['references'] == '<message-id@test.com>'
    end
  end

  test 'supports multiple references' do
    t = TestMailer.welcome_email
    t.references = '<message-id@test.com> <message-id2@test.com>'
    t.deliver!

    assert_requested(
      :post, 'https://app.mailpace.com/api/v1/send',
      times: 1
    ) do |req|
      JSON.parse(req.body)['references'] == '<message-id@test.com> <message-id2@test.com>'
    end
  end

  # TODO: subject, to etc.
end
