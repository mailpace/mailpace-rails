# frozen_string_literal: true

module Ohmysmtp
  # Provides the delivery method & sets up action mailbox
  class Engine < ::Rails::Engine
    initializer 'ohmysmtp.add_delivery_method', before: 'action_mailer.set_configs' do
      ActionMailer::Base.add_delivery_method(:ohmysmtp, Ohmysmtp::DeliveryMethod)
    end

    config.action_mailbox.ohmysmtp = ActiveSupport::OrderedOptions.new
  end
end
