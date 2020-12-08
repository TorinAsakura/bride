require 'authorization_builder'

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :html, :js

  def success
    respond_with(resource) do |format|
      format.html { render layout: !request.xhr? }
    end
  end

  def create
    build_resource(sign_up_params)
    if @form.save
      @form.user.set_default_city!(request.ip)
      if @form.user.active_for_authentication?
        flash[:client_first_visit] = true if @form.user.client?
        sign_up(resource_name, @form.user)
        if request.xhr?
          render js: "window.location = '#{root_path}'"
        else
          respond_with @form.user, location: after_sign_up_path_for(@form.user)
        end
      else
        expire_session_data_after_sign_in!
        flash_popup_message('devise.failure.inactive', false, @form.user.email)
        respond_with @form.user, location: after_inactive_sign_up_path_for(@form.user)
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  private
  def random_password
    o = [('a'..'z'), ('A'..'Z'), ('0'..'9')].map { |i| i.to_a }.flatten
    (0...12).map { o[rand(o.length)] }.join
  end

  def build_resource(sign_up_params)
    @client_form = ClientRegistrationForm.new(sign_up_params)
    @firm_form = FirmRegistrationForm.new(sign_up_params)
    @form = params[:profile_type] == 'client' || !params.has_key?(:profile_type) ? @client_form : @firm_form

    build_socialized_resource if request_with_omniauth?(session, params)
    self.resource = @form.user || @form
  end

  protected
  def after_sign_up_path_for resource
    session[:just_signed_up] = true
    super(resource)
  end

  def build_socialized_resource
    @form.password = random_password
    @form.read = params[:read]
    @form.with_provider = params[:with_provider]

    @authorization = User::Authorization.find_by_token(session[:omniauth_token])
    @form.email = @authorization.email if  @form.email.blank?

    if @authorization.email && @form.email
      @form.read = true
    end

    if @form.save
      AuthorizationBuilder.set_with_omniauth! session[:omniauth_token], @form.user
    end
  end

  def request_with_omniauth?(session, params)
    session[:omniauth_token] && params[:with_provider] == 'true'
  end
end

