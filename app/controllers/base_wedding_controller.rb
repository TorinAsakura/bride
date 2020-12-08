# encoding: utf-8
class BaseWeddingController < ActionController::Base
  include Controllers::Application
  layout 'application'
  before_filter :authenticate_user!, unless: :devise_controller?
  before_filter :set_layout_data
  helper_method :current_client, :current_firm, :current_wedding

  private
  def current_wedding
    current_client.try(:wedding).try(:decorate)
  end

  def set_layout_data
    @wedding_firm_catalogs = FirmCatalog.roots.ordered.includes(:children)
    @wedding_cities = City.enabled_for_firms.ordered.includes(region: :country)
  end
end
