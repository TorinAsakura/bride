# encoding: utf-8
class UserMailer < ActionMailer::Base
  default from: 'info@svadba.org'

  def send_email(email, body, title)
    @body = body
    mail(to: email, subject: title)
  end
end
