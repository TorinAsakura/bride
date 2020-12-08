# encoding: utf-8
require 'authorization_builder'

class AuthorizationsController < ApplicationController
  include SocialServicesHelper
  respond_to :html, :js
  skip_before_filter :authenticate_user!

  def create
    if !omniauth
      logger.debug 'no omniauth'
      flash[:alert] = I18n.t('social_accounts.flash.something_wrong')
      redirect_to root_path
    else
      if user_signed_in?
        add_authorization
      elsif try_sign_in_by_email
        sign_in(@current_user)
      else
        if authorization_exists?
          sign_in_with_omniauth
        else
          sign_up_with_omniauth
        end
      end
    end
  end

  def auth_failure
    redirect_to '/users/sign_in', :alert => params[:message]
  end

  def destroy
    @account = current_user.authorizations.find(params[:id])
    @account.destroy
    respond_with(@account)
  end

  private

  def omniauth
    request.env['omniauth.auth']
  end

  def add_authorization
    auth_builder = AuthorizationBuilder.new(omniauth, current_user)
    auth_builder.create_authorization

    if request_from_social_services?
      render :text => t('notice.social_auth_successful')
      #redirect_to @referrer_path
      clear_social_request_referrer_path
    else
      redirect_to edit_client_path(current_user.profileable)
    end
  end

  def authorization_exists?
    @authorization = User::Authorization.where(
        :provider => omniauth['provider'], :uid => omniauth['uid'].to_s
    ).first
  end

  def sign_in_with_omniauth
    flash[:notice] = I18n.t('social_accounts.flash.assigned')
    #t(:signed_in_successfully)
    if @authorization.user
      #redirect_to edit_client_path(@authorization.user)
      sign_in_and_redirect(:user, @authorization.user)
    else
      session[:omniauth_token] = @authorization.token
      redirect_to new_user_registration_url(subdomain: nil, with_provider: true)
    end
  end

  def sign_up_with_omniauth
    auth_builder = AuthorizationBuilder.new(omniauth)
    auth_builder.create_authorization
    session[:omniauth_token] = auth_builder.authorization.token
    redirect_to new_user_registration_url(subdomain: false, with_provider: true)
  end

  def try_sign_in_by_email
    logger.debug "try_sign_in_by_email info: #{omniauth.info}"
    if omniauth.info.email && (try_user = User.find_by_email(omniauth.info.email)) && try_user.confirmed_at
      case omniauth['provider']
        when 'google_oauth2'
          @current_user = try_user if omniauth.extra.raw_info.verified_email
        when 'facebook'
          @current_user = try_user if omniauth.info.verified
      end
      if @current_user && (auth = authorization_exists?) && auth.user_id == nil
        auth.update_attribute :user_id, @current_user.id
      end
    end
    @current_user
  end
end
