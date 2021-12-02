class ListUnsubscribeMailer < ApplicationMailer
    default from: 'notifications@example.com',
            to: 'fake@sdfasdfsdaf.com'

    def unsubscribe
      mail(
        list_unsubscribe: 'test list-unsubscribe'
      )
    end
end
