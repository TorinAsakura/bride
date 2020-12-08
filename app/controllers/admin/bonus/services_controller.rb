class Admin::Bonus::ServicesController < AdminController
  layout 'admin_application'
  respond_to :html
  #load_and_authorize_resource

  def index
    @services = ::Bonus::Service.ordered.decorate
    respond_with(@services)
  end

  def new
    @service = ::Bonus::Service.new
    respond_with(@service)
  end

  def create
    @service = ::Bonus::Service.new(params[:bonus_service])
    respond_to do |format|
      if @service.save
        format.html{ redirect_to admin_bonus_services_path}
      else
        format.html{ render action: :new}
      end
    end
  end

  def edit
    @service = ::Bonus::Service.find(params[:id])
    respond_with(@service)
  end

  def update
    @service = ::Bonus::Service.find(params[:id])
    respond_to do |format|
      if @service.update_attributes(params[@service.class.name.underscore.tr('/', '_').to_sym])
        format.html{ redirect_to admin_bonus_services_path}
      else
        format.html{ render action: :edit}
      end
    end
  end

  def destroy
    @service = ::Bonus::Service.find(params[:id])
    @service.destroy
    respond_with(@service)
  end

  def sort
    params[:ids].each_with_index do |id, index|
      ::Bonus::Service.find(id).update_attribute(:position, index.to_i+1)
    end
    render nothing: true
  end
end
