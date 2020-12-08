# encoding: utf-8
class Seating::SeatsController < Seating::BaseController
  respond_to :json
  before_filter :set_table
  before_filter :set_seat, only: [:update, :destroy]

  def create
    @seat = @table.seats.create(params[:seat])
    render json: @seat
  end

  def update
    @seat.update_attributes(params[:seat])
    render json: @seat
  end

  def destroy
    @seat.destroy
    render json: @seat
  end

  protected
  def set_table
    @table = @plan.tables.find(params[:table_id])
  end

  def set_seat
    @seat = @table.seats.find(params[:id])
  end
end
