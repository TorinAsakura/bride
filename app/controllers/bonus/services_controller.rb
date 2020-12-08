class Bonus::ServicesController < ApplicationController
  respond_to :js, :json

  def index
    @services = Bonus::Service.list.ordered.decorate
    @firm = Firm.find(request.subdomain)
    respond_with(@services) do |format|
      format.js
    end
  end

  def price
    firm = Firm.find(params[:firm_id])
    @service = Bonus::Service.find(params[:id])
    price = if (city_id = params[:city_id]).present?
              city = City.find(city_id)
              @service.price(firm, city)
            elsif (firm_catalog_id = params[:firm_catalog_id]).present?
              firm_catalog = FirmCatalog.find(firm_catalog_id)
              @service.price(firm, firm_catalog)
            end
    respond_with(@service) do |format|
      format.json{ render status: :ok, json: {price: price.format(html:true).html_safe}}
    end
  end
end
