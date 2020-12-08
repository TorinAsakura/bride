# encoding: utf-8
class Seating::TablesController < Seating::BaseController
  respond_to :json
  before_filter :set_table, only: [:update, :destroy]

  def create
    @table = @plan.tables.create(params[:table])
    render json: @table
  end

  def update
    @table.update_attributes(params[:table])
    render json: @table
  end

  def destroy
    @table.destroy
    render json: @table
  end

  protected
  def set_table
    @table = @plan.tables.find(params[:id])
  end
end
