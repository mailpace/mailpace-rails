Rails.application.routes.draw do
  post 'rails/action_mailbox/mailpace/inbound_emails', to: 'action_mailbox/ingresses/mailpace/inbound_emails#create',
                                                       as: 'rails_mailpace_inbound_emails'
end
