# encoding: utf-8
class Admin::FirmCatalogsController < AdminController
  layout 'admin_application'
  include TheSortableTreeController::Rebuild
  include TheSortableTreeController::ExpandNode

  respond_to :js, :html, :json

  before_filter :find_firm_catalog, only: [:edit, :update, :destroy]

  def index
    @form_catalogs = FirmCatalog.nested_set.roots.select('id, name, parent_id, logo, children_count, extended_name, category, slug').all
  end

  def new
    @parent = (parent_id = params[:parent_id]).present? && FirmCatalog.find(parent_id)
    @firm_catalog = @parent ? @parent.children.build : FirmCatalog.new
    respond_with(@firm_catalog) do |format|
      format.js
    end
  end

  def create
    firm_catalog_params = params[:firm_catalog].slice!(:parent_id)
    @parent = (parent_id = params[:firm_catalog][:parent_id]).present? && FirmCatalog.find(parent_id)
    @firm_catalog = (@parent ? @parent.children : FirmCatalog).create(firm_catalog_params)
    respond_with(@firm_catalog) do |format|
      format.html { redirect_to admin_firm_catalogs_path}
      format.js
    end
  end

  def edit
    respond_with(@firm_catalog) do |format|
      format.js
    end
  end

  def update
    @firm_catalog.update_attributes(params[:firm_catalog])
    respond_with(@firm_catalog) do |format|
      format.html { redirect_to admin_firm_catalogs_path}
      format.js
      format.json{ respond_with_bip(@firm_catalog)}
    end
  end

  def destroy
    @firm_catalog.destroy
    respond_with(@firm_catalog) do |format|
      format.js
    end
  end

  private
  def find_firm_catalog
    @firm_catalog = FirmCatalog.find(params[:id])
  end
end
