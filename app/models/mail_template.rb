# encoding: utf-8
# require 'delivery_worker'
class MailTemplate < ActiveRecord::Base
  attr_accessible :body, :send_date, :title

  validates :title, presence: true
  validates :body,  presence: true

  def send_to(emails)
    emails.each { |e| UserMailer.delay.send_email(e, self.body, self.title) }
  end
  # TODO add liquid templates
end
