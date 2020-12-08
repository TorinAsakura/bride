class PursePaymentsController < ApplicationController
  respond_to :js

  def index
    @purse_payments = current_firm.purse.purse_payments.ordered
    if %w(all deposit withdrawal).include? params[:scope]
      @scope = params[:scope]
      @purse_payments = @purse_payments.send(@scope) unless @scope.eql?('all')
    end
    @per = params[:per].eql?('all') ? @purse_payments.count : params[:per]
    @page = params[:page]
    @purse_payments = PursePaymentDecorator.decorate_collection(@purse_payments.page(@page).per(@per))
    respond_with(@purse_payments) do |format|
      format.js
    end
  end
end