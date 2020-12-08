# encoding: utf-8
class DealersController < ApplicationController
  include ControllersExt::FirmPrivate

  respond_to :html, :js

  def show
    @firm = Firm.find_by_slug!(request.subdomain(Subdomain.position))
    redirect_to firm_path(@firm) and return unless current_user.has_role(:moderation, @firm)
    set_public_variables
    @children_firms = @firm.children_firms
  end

  def new_transfer_to_system
    @transfer_to_system = PursePayment::TransferToSystem.new
    respond_to do |format|
      format.js
    end
  end

  def transfer_to_system
    @transfer_to_system = current_firm.purse_payment_transfer_to_systems.build(params[:purse_payment_transfer_to_system])
    @transfer_to_system.purse = current_firm.purse
    @transfer_to_system.complete! if @transfer_to_system.save
    respond_to do |format|
      format.js
    end
  end
end