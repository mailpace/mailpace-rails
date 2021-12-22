Rails.application.routes.draw do
  post 'rails/action_mailbox/ohmysmtp/inbound_emails', to: 'action_mailbox/ingresses/ohmysmtp/inbound_emails#create',
                                                       as: 'rails_ohmysmtp_inbound_emails'
end
