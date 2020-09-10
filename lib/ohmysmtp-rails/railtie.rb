module OhMySMTP
  class Railtie < ::Rails::Railtie
    initializer 'ohmysmtp.add_delivery_method', before: 'action_mailer.set_configs' do
      ActionMailer::Base.add_delivery_method(:ohmysmtp, OhMySMTP::DeliveryMethod)
    end
  end
end
