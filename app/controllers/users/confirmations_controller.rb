class Users::ConfirmationsController < Devise::ConfirmationsController

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      flash_popup_message('devise.confirmations.confirmed')
      sign_in(resource)
      respond_with_navigational(resource){ redirect_to root_path }
    else
      flash_popup_message('devise.confirmations.user.error_confirm_token', 'now', @user.email) if params.has_key?(:confirmation_token)
      respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
    end
  end
end
