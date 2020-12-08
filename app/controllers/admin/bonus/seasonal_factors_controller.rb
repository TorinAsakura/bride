class Admin::Bonus::SeasonalFactorsController < AdminController
  layout 'admin_application'
  respond_to :html, :json
  before_filter :set_service

  def index
    @seasonal_factors = @service.seasonal_factors
    respond_with(@seasonal_factors)
  end

  def update
    @seasonal_factor = @service.seasonal_factors.find params[:id]
    @seasonal_factor.update_attributes(params[:bonus_seasonal_factor])
    respond_with @seasonal_factor do |format|
      format.json { respond_with_bip(@seasonal_factor)}
    end
  end

  protected
  def set_service
    @service = ::Bonus::Service.find(params[:service_id])
  end
end