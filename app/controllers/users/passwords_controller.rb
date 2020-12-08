class Users::PasswordsController < Devise::PasswordsController
  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    flash_popup_message('devise.passwords.send_instructions', false, @user.email)
    redirect_to root_url(subdomain: false)
  end
end
