# encoding: utf-8
class SpheresController < ApplicationController
  respond_to :js

  def create
    @firm = Firm.find params[:firm_id]
    redirect_to edit_firm_path(@firm) and return unless (@firm.user.is? current_user || current_user.has_role?(:admin))
    @firm_catalog = FirmCatalog.find(params[:sphere][:firm_catalog_id])
    @sphere = @firm.spheres.create(firm_catalog_id: @firm_catalog.id)
    respond_with(@sphere)
  end

  def destroy
    #TODO add can
    @firm = Firm.find params[:firm_id]
    @sphere = @firm.spheres.with_deleted.find params[:id]
    @sphere.deleted? ? @sphere.send(:paranoid_recover!) : @sphere.destroy
    respond_with(@sphere)
  end
end