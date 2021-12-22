# frozen_string_literal: true

module ActionMailbox
  module Ingresses
    module Ohmysmtp
      # Ingests inbound emails from OhMySMTP. Uses the a +raw+ parameter containing the full RFC 822 message.
      #
      # Authenticates requests using HTTP basic access authentication. The username is always +actionmailbox+, and the
      # password is read from the application's encrypted credentials or an environment variable. See the Usage section.
      #
      # Returns:
      #
      # - <tt>204 No Content</tt> if an inbound email is successfully recorded and enqueued for routing
      # - <tt>401 Unauthorized</tt> if the request's signature could not be validated
      # - <tt>404 Not Found</tt> if Action Mailbox is not configured to accept inbound emails from OhMySMTP
      # - <tt>422 Unprocessable Entity</tt> if the request is missing the required +RawEmail+ parameter
      # - <tt>500 Server Error</tt> if the ingress password is not configured, or if one of the Active Record database,
      #   the Active Storage service, or the Active Job backend is misconfigured or unavailable
      #
      # == Usage
      #
      # 1. Tell Action Mailbox to accept emails from OhMySMTP:
      #
      #        # config/environments/production.rb
      #        config.action_mailbox.ingress = :ohmysmtp
      #
      # 2. Generate a strong password that Action Mailbox can use to authenticate requests to the OhMySMTP ingress.
      #
      #    Use <tt>bin/rails credentials:edit</tt> to add the password to your application's encrypted credentials under
      #    +action_mailbox.ingress_password+, where Action Mailbox will automatically find it:
      #
      #        action_mailbox:
      #          ingress_password: ...
      #
      #    Alternatively, provide the password in the +RAILS_INBOUND_EMAIL_PASSWORD+ environment variable.
      #
      # 3. {Configure OhMySMTP}[https://docs.ohmysmtp.com/guide/inbound] to forward inbound emails
      #    to +/rails/action_mailbox/ohmysmtp/inbound_emails+ with the username +actionmailbox+ and the password you
      #    previously generated. If your application lived at <tt>https://example.com</tt>, you would configure your
      #    OhMySMTP inbound endpoint URL with the following fully-qualified URL:
      #
      #        https://actionmailbox:PASSWORD@example.com/rails/action_mailbox/ohmysmtp/inbound_emails
      #
      class InboundEmailsController < ActionMailbox::BaseController
        before_action :authenticate_by_password

        def create
          ActionMailbox::InboundEmail.create_and_extract_message_id! params.require('raw')
        rescue ActionController::ParameterMissing => e
          logger.error e.message

          head :unprocessable_entity
        end
      end
    end
  end
end
