class Admin::Bonus::CityDealerPercentsController < AdminController
  layout 'admin_application'
  respond_to :html, :json
  before_filter :set_service

  def index
    @cities = City.enabled_for_firms
    respond_to do |format|
      format.html
    end
  end

  def update_city_dealer_percent
    city = City.find params[:city_id]
    @city_dealer_percent = @service.city_dealer_percents.city(city)
    @city_dealer_percent.update_attributes(params[:bonus_city_dealer_percent])
    respond_with @city_dealer_percent do |format|
      format.json { respond_with_bip(@city_dealer_percent)}
    end
  end

  protected
  def set_service
    @service = ::Bonus::Service.find(params[:service_id])
  end
end