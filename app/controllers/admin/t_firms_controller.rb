class Admin::TFirmsController < ApplicationController
  layout 'admin_application'
  respond_to :js, :html, :json

  load_and_authorize_resource

  def index
    search = params[:search]
    @t_firms = (search.present? && (firm_catalog_id = search[:firm_catalog_id]).present? ? FirmCatalog.find(firm_catalog_id).t_firms : TFirm).ordered
    @t_firms = @t_firms.filtered(search).page(params[:page])
    respond_with(@t_firms)
  end

  def update
    @t_firm.update_attributes(params[:t_firm])
    respond_to do |format|
      format.html { redirect_to admin_t_firms_path}
      format.js
      format.json{ respond_with_bip(@t_firm)}
    end
  end

  def destroy
    @t_firm.destroy
    respond_to do |format|
      format.html { redirect_to admin_t_firms_path, notice: 'Временная Фирма была успешно удалена' }
      format.js
    end
  end
end
