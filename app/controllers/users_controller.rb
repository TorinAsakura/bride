# encoding: utf-8
class UsersController < ApplicationController
  before_filter :redirect, except: [:check_email_present, :update_phone, :check_email]
  before_filter :find_user, only: :update_phone
  before_filter :authorize_moderator, only: :update_phone

  skip_before_filter :authenticate_user!, only: [:check_email_present, :check_email]

  def show
  end

  def edit
  end

  def check_email_present
    email = User.where('users.email = ?', params[:user_email])
    if email.present? && current_user.email != params[:user_email]
      render :json => {:result => true, :message => I18n.t('activerecord.errors.models.user.attributes.email.taken')}
    else
      render :json => {:result => false}
    end
  end

  def check_email
    user_with_email = User.where('users.email = ?', params[:user_email])
    if user_with_email.present?
      render :json => {:result => true, :message => I18n.t('activerecord.errors.models.user.attributes.email.taken')}
    else
      render :json => {:result => false}
    end
  end

  def update_phone
    params[:user][:phone] = params[:user][:phone_prefix] + params[:user][:phone_body]
    respond_to do |format|
      @phone_changed = true if  @user.update_attributes(params[:user].slice(:phone))
      format.js { render template: 'users/update_actions/main_settings/update_phone', layout: false }
    end
  end

  private
  def find_user
    @user = User.find(params[:id])
  end

  def authorize_moderator
    authorize_or_gtfo :moderate, @user.profileable, root_path
  end

  def redirect
    profileable = (User.find(params[:id]) || current_user).profileable
    controller, id = case profileable.class.to_s
    when 'Client'
      ['clients', profileable.id]
    when 'Firm'
      ['firms', profileable.slug]
    end
    redirect_to controller: controller, :action =>  params[:action], id: id
  end
end
