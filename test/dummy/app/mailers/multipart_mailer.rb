class MultipartMailer < ApplicationMailer
  default from: 'notifications@example.com',
          to: 'fake@sdfasdfsdaf.com'

  def no_text_email
    attachments['terms.pdf'] = {
      mime_type: 'application/pdf',
      content: "%PDF-1.4\n%Fake PDF content\n%%EOF"
    }

    mail(subject: 'Test Email with Attachment')
  end

  def no_html_email
    attachments['terms.pdf'] = {
      mime_type: 'application/pdf',
      content: "%PDF-1.4\n%Fake PDF content\n%%EOF"
    }

    mail(subject: 'Test Email with Attachment')
  end
end
