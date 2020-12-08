class Users::SessionsController < Devise::SessionsController
  respond_to :js, :html

  def create
    #NOTE uncomment after work with fake users has gone
    # @user = User.where(login: params[:user][:login]).first
    # if @user && @user.confirmed_at.nil?
    #   @user.send_confirmation_instructions
    #   flash_popup_message('devise.failure.inactive', false, @user.email)
    #   redirect_to root_path
    # else
    # end
    downcase_email_from_form!
    @user_form = UserSignInForm.new(form_sign_in_params)

    if @user_form.valid?
      self.resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)
      yield resource if block_given?

      @redirect_url = after_sign_in_path_for(resource)

      if request.xhr?
        render js: "window.location = '#{@redirect_url}'"
      else
        respond_with resource, location: @redirect_url
      end
    else
      respond_with @user_form
    end
  end

  private
  def downcase_email_from_form!
    self.env['rack.request.form_hash']['user']['login'].downcase!
  end

  #def can_sign_in_with_params?(auth_options)
    #!!warden.authenticate(auth_options)
  #end

  def form_sign_in_params
    self.env['rack.request.form_hash']['user']
  end
end
