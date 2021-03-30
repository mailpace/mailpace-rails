class TagMailer < ApplicationMailer
  default from: 'notifications@example.com',
          to: 'fake@sdfasdfsdaf.com'

  def single_tag
    mail(
      tags: 'test tag'
    )
  end

  def multi_tag
    mail(
      tags: "['test tag', 'another-tag']"
    )
  end
end
