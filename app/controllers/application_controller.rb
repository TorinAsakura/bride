# encoding: utf-8
class ApplicationController < ActionController::Base
  include Controllers::Application
  protect_from_forgery
  before_filter :authenticate_user!, unless: :devise_controller?
  before_filter :check_admin_scope
  before_filter :set_layout_data
  helper_method :current_client, :current_firm

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  private
  def check_admin_scope
    if params[:controller].start_with? 'admin/'
       # raise ActionController::RoutingError.new('Not Found') unless current_user.has_role? :admin
    end
  end

  def signed_in_root_path(resource)
    resource.client? ? user_path(resource) : view_context.firm_link(resource.firm)
  end

  def redirect_back(notice=nil)
    session[:return_to] ||= request.referer
    if notice
      message = notice[0]=='!' ? {alert:notice[1..-1]} : {notice:notice}
      redirect_to (session.delete(:return_to)), message
      return
    end
    redirect_to session.delete (:return_to)
  end

  def find_site
    @site = Site.find_by_name(request.subdomain(Subdomain.position)).try(:decorate)
    redirect_to( view_context.main_domain_link(request.fullpath) ) and return unless @site
    @pages = @site.try(:pages)
  end

  def authorize_or_gtfo(role, resource, path)
    authorize! role, resource rescue CanCan::AccessDenied redirect_to path
  end

  def access_checks_on_minisite
    if @site && @site.privacy? && session["site_code_#{@site.id}"] != @site.code &&
       params[:controller] != 'minisite/minisites' && params[:page] != 'about'
      redirect_to minisite_page_path('about') if current_user.blank? || user_signed_in? && !@site.client.user.is?(current_user) 
    end
  end

  def flash_popup_message yml_path, visibility = false, user_email = false
    visibility.present? ? (flash.now[:info] = Hash.new) : (flash[:info] = Hash.new)
    flash[:info][:title] = t("#{yml_path}.title")
    flash[:info][:body] = user_email.present? ? t("#{yml_path}.body", user_email: user_email) : t("#{yml_path}.body") 
  end

  def set_layout_data
    @wedding_firm_catalogs = FirmCatalog.roots.ordered.includes(:children)
    @wedding_cities = City.enabled_for_firms.ordered.includes(region: :country)
  end
end
