class Admin::Bonus::PricesController < AdminController
  layout 'admin_application'
  respond_to :html, :json
  before_filter :set_service

  def index
    @firm_catalogs = FirmCatalog.top
    respond_to do |format|
      format.html
    end
  end

  def update_price
    firm_catalog = FirmCatalog.find params[:firm_catalog_id]
    @price = @service.prices.firm_catalog(firm_catalog)
    @price.update_attributes(params[:bonus_price])
    respond_with @price do |format|
      format.json { respond_with_bip(@price)}
    end
  end

  protected
  def set_service
    @service = ::Bonus::Service.find(params[:service_id])
  end
end
