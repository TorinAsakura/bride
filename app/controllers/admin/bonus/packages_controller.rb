class Admin::Bonus::PackagesController < AdminController
  layout 'admin_application'
  respond_to :html, :json
  before_filter :set_service

  def index
    @packages = @service.packages
    respond_with(@packages)
  end

  def new
    @package = @service.packages.build
    respond_with(@package)
  end

  def create
    @package = @service.packages.build(params[:bonus_package])
    respond_with @package do |format|
      if @package.save
        format.html { redirect_to admin_bonus_service_packages_path(@service) }
      else
        format.html { render action: :new}
      end
    end
  end

  def update
    @package = @service.packages.find params[:id]
    @package.update_attributes(params[:bonus_package])
    respond_with @package do |format|
      format.json { respond_with_bip(@package)}
    end
  end

  protected
  def set_service
    @service = ::Bonus::Service.find(params[:service_id])
  end
end