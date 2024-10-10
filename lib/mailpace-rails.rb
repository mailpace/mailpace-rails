require 'action_mailer'
require 'action_mailbox/engine'
require 'httparty'
require 'uri'
require 'json'
require 'mailpace-rails/version'
require 'mailpace-rails/engine' if defined? Rails

module Mailpace
  # MailPace ActionMailer delivery method
  class DeliveryMethod
    attr_accessor :settings

    def initialize(values)
      check_api_token(values)
      self.settings = { return_response: true }.merge!(values)
    end

    def deliver!(mail)
      check_delivery_params(mail)
      result = HTTParty.post(
        'https://app.mailpace.com/api/v1/send',
        body: {
          from: address_list(mail.header[:from])&.addresses&.first.to_s,
          to: mail.to.join(','),
          subject: mail.subject,
          htmlbody: mail.html_part ? mail.html_part.body.decoded : mail.body.to_s,
          textbody: if mail.multipart?
                      mail.text_part ? mail.text_part.body.decoded : nil
                    end,
          cc: address_list(mail.header[:cc])&.addresses&.join(','),
          bcc: address_list(mail.header[:bcc])&.addresses&.join(','),
          replyto: mail.reply_to&.join(','),
          list_unsubscribe: mail.header['list_unsubscribe'].to_s,
          attachments: format_attachments(mail.attachments),
          tags: mail.header['tags'].to_s
        }.delete_if { |_key, value| value.blank? }.to_json,
        headers: {
          'User-Agent' => "MailPace Rails Gem v#{Mailpace::Rails::VERSION}",
          'Accept' => 'application/json',
          'Content-Type' => 'application/json',
          'Mailpace-Server-Token' => settings[:api_token],
          'Idempotency-Key' => mail.header['idempotency_key']
        }
      )

      handle_response(result)
    end

    private

    def check_api_token(values)
      return if values[:api_token].present?

      raise ArgumentError, 'MailPace API token is not set'
    end

    def check_delivery_params(mail)
      return unless mail.from.nil? || mail.to.nil?

      raise ArgumentError, 'Missing to or from address in email'
    end

    def handle_response(result)
      return result unless result.code != 200

      # TODO: Improved error handling
      res = result.parsed_response
      raise res['error']&.to_s || res['errors']&.to_s
    end

    def format_attachments(attachments)
      attachments.map do |attachment|
        {
          name: attachment.filename,
          content_type: attachment.mime_type,
          content: Base64.encode64(attachment.body.encoded),
          cid: attachment.content_id
        }.compact
      end
    end

    def address_list(obj)
      if obj&.respond_to?(:element)
        # Mail 2.8+
        obj.element
      else
        # Mail <= 2.7.x
        obj&.address_list
      end
    end
  end

  class Error < StandardError; end

  def self.root
    Pathname.new(File.expand_path(File.join(__dir__, '..')))
  end
end
