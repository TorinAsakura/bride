class Admin::Bonus::CityRatiosController < AdminController
  layout 'admin_application'
  respond_to :html, :json
  before_filter :set_service

  def index
    @cities = City.enabled_for_firms
    respond_to do |format|
      format.html
    end
  end

  def update_city_ratio
    city = City.find params[:city_id]
    @city_ratio = @service.city_ratios.city(city)
    @city_ratio.update_attributes(params[:bonus_city_ratio])
    respond_with @city_ratio do |format|
      format.json { respond_with_bip(@city_ratio)}
    end
  end

  protected
  def set_service
    @service = ::Bonus::Service.find(params[:service_id])
  end
end