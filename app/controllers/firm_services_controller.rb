# encoding: utf-8
class FirmServicesController < InheritedResources::Base
  belongs_to :firm
  respond_to :js
  before_filter :check_owner

  def change_rating
    params[:ids].each_with_index do |id, index|
      current_firm.firm_services.find(id).update_attribute(:raiting, index.to_i+1)
    end
    render nothing: true
  end

  def new
    @service = @firm.firm_services.build
  end

  def create
    create! { render(action: :index) and return }
  end

  def update
    update! { render(action: :index) and return }
  end

  def destroy
    destroy! { render(action: :index) and return }
  end

  protected
  def check_owner
    @firm = Firm.find(params[:firm_id])
    redirect_to root_path unless (@firm.user == current_user || current_user.has_role?(:admin))
  end
end