require 'action_mailer'
require 'ohmysmtp-rails/railtie' if defined? Rails

module OhMySMTP
  class DeliveryMethod
    def initialize(params)
      # ???
    end

    def deliver!(mail)
      ## oms http call goes here
      ## plus hooks before_send and after_send hooks
    end
  end
end
