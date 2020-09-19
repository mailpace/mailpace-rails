require 'action_mailer'
require 'httparty'
require 'uri'
require 'json'
require 'ohmysmtp-rails/version'
require 'ohmysmtp-rails/railtie' if defined? Rails

module OhMySMTP
  # OhMySMTP ActionMailer delivery method
  class DeliveryMethod
    attr_accessor :settings

    def initialize(values)
      check_api_token(values)
      self.settings = {}.merge!(values)
    end

    def deliver!(mail)
      check_delivery_params(mail)
      result = HTTParty.post(
        'https://app.ohmysmtp.com/api/v1/send',
        body: {
          from: mail.from.join(','),
          to: mail.to.join(','),
          subject: mail.subject,
          htmlbody: mail.body.to_s,
          cc: mail.cc&.join(','),
          bcc: mail.bcc&.join(','),
          replyto: mail.reply_to
        }.to_json,
        headers: {
          'User-Agent' => "OhMySMTP Rails Gem v#{OhMySMTP::Rails::VERSION}",
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Ohmysmtp-Server-Token' => settings[:api_token]
        }
      )

      handle_response(result)
    end

    private

    def check_api_token(values)
      return if values[:api_token].present?

      raise ArgumentError, 'OhMySMTP API token is not set'
    end

    def check_delivery_params(mail)
      return unless mail.from.nil? || mail.to.nil?

      raise ArgumentError, 'Missing to or from address in email'
    end

    def handle_response(result)
      return unless result.code != 200

      # TODO: Improved error handling
      res = result.parsed_response
      raise res['error']&.to_s || res['errors']&.to_s
    end
  end
end
