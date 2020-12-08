class Admin::Bonus::LoyaltiesController < AdminController
  layout 'admin_application'
  respond_to :html, :json
  before_filter :set_service

  def index
    @loyalties = @service.loyalties
    respond_with(@loyalties)
  end

  def update
    @loyalty = @service.loyalties.find params[:id]
    @loyalty.update_attributes(params[:bonus_loyalty])
    respond_with @loyalty do |format|
      format.json { respond_with_bip(@loyalty)}
    end
  end

  protected
  def set_service
    @service = ::Bonus::Service.find(params[:service_id])
  end
end