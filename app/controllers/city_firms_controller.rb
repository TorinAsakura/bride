# encoding: utf-8
class CityFirmsController < InheritedResources::Base
  respond_to :js

  before_filter :find_firm
  before_filter :find_city, only: :create
  before_filter :authorize_moderator

  def new; end

  def create
    @city_firm = @firm.city_firms.create(city_id: @city.id)
  end

  def update
    @city_firm = @firm.all_city_firms.find(params[:id])
    @base_address = @city_firm.base_address || Address.new(city_firm: @city_firm)
    @base_address.update_attributes(params[:address])
    super
  end

  def destroy
    @city_firm = @firm.city_firms.with_deleted.find params[:id]
    @city_firm.deleted? ? @city_firm.send(:paranoid_recover!) : @city_firm.destroy
  end

  def rating
    params[:ids].each_with_index do |id, index|
      @firm.all_city_firms.find(id).update_attribute(:rating, index.to_i+1)
    end
    render nothing: true
  end

  def change_city
    @city_firm = @firm.all_city_firms.find(params[:id])
    @city_firm.update_attribute(:city_id, params[:city_firm][:city_id])
    render nothing: true
  end
 
  protected
  def find_firm
    @firm = params[:firm_id].present? ? Firm.find(params[:firm_id]) : Firm.find(request.subdomain)
  end

  def find_city
    @city = City.find(params[:city_id] || params[:city_firm][:city_id])
  end

  def authorize_moderator
    authorize_or_gtfo :moderate, @firm, root_path
  end
end