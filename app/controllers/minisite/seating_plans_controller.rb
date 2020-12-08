# encoding: utf-8
class Minisite::SeatingPlansController < Minisite::BaseController
  respond_to :html, :json
  skip_before_filter :authenticate_user!
  before_filter :set_seating_plan

  def show
    @guests = @site.guests
    @with_menu = false
    respond_with(@seating_plan)
  end

  def get_data
    render json: @seating_plan
  end

  protected
  def set_seating_plan
    @seating_plan = @site.seating_plan
  end
end
