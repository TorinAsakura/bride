# encoding: utf-8
class Seating::PlansController < Seating::BaseController
  def show
    respond_with(@plan) do |format|
      format.json {render @plan}
    end
  end

  def edit
    respond_with(@plan)
  end

  def update
    # TODO add check active plan
  end
end
