# frozen_string_literal: true

module Mailpace
  # Provides the delivery method & sets up action mailbox
  class Engine < ::Rails::Engine
    initializer 'mailpace.add_delivery_method', before: 'action_mailer.set_configs' do
      ActiveSupport.on_load(:action_mailer) do
        add_delivery_method(:mailpace, Mailpace::DeliveryMethod)
      end
    end

    config.action_mailbox.mailpace = ActiveSupport::OrderedOptions.new
  end
end
