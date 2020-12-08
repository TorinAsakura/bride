# encoding: utf-8
class DeviseCustomMailer < Devise::Mailer
  include AbstractController::Callbacks
  layout 'user_mailer'

  before_filter :add_inline_attachment!

  def confirmation_instructions(record, token, opts={})
    super
  end

  def reset_password_instructions(record, token, opts={})
    super
  end

  def unlock_instructions(record, token, opts={})
    super
  end

  private
  def add_inline_attachment!
    attachments.inline['big_logo.png'] = File.read(File.join(Rails.root,'app','assets','images','mail','sv-mail-welcome-logo.png'))
    attachments.inline['logo.png'] = File.read(File.join(Rails.root,'app','assets','images','mail','sv-mail-logo.png'))
    attachments.inline['banner1.png'] = File.read(File.join(Rails.root,'app','assets','images','mail','sv-mail-banner1.png'))
    attachments.inline['banner2.png'] = File.read(File.join(Rails.root,'app','assets','images','mail','sv-mail-banner2.png'))
    attachments.inline['banner3.png'] = File.read(File.join(Rails.root,'app','assets','images','mail','sv-mail-banner3.png'))
  end
end
