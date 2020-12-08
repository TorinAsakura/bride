# encoding: utf-8
class AddressesController < ApplicationController
  respond_to :js, :html

  before_filter :check_edit_ability, :except => [:index]

  def new
    @address = @firm.addresses.new
    @address.phone_numbers.build
    respond_with(@address) do |format|
      format.js { }
    end
  end

  def create
    @address = @firm.addresses.create(params[:address])
    redirect_to edit_firm_path(@firm)
  end

  def edit
    @address = @firm.addresses.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def update
    @address = @firm.addresses.find(params[:id])
    @address.update_attributes(params[:address])
    redirect_to edit_firm_path(@firm, anchor: 'addresses')
  end

  def destroy
    @address = @firm.addresses.find(params[:id])
    @address.destroy
    redirect_to edit_firm_path(@firm)
  end

  def sort

    if (city_firm_id = params[:city_firm_id]).present? && (city_firm = @firm.all_city_firms.find(city_firm_id)).present?
      params[:ids].each_with_index do |id, index|
        city_firm.addresses.find(id).update_attribute(:position, index.to_i+1)
      end
    end
    render nothing: true
  end

  private
  def check_edit_ability
    @firm = Firm.find(params[:firm_id])
    redirect_to root_url unless @firm.user.id == current_user.id
  end
end
