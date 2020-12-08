# encoding: utf-8
class PaymentsController < InheritedResources::Base
  belongs_to :firm

  respond_to :html

  def create
    create! do |format|
      @payment.direction = :income
      if @payment.save # success
        format.html { render :create }
      else
        format.html { render :new }
      end
    end
  end

end
