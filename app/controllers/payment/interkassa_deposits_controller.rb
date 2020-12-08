class Payment::InterkassaDepositsController < ApplicationController
  before_filter :authenticate_user!, except: :result
  respond_to :html, :js
  skip_before_filter :verify_authenticity_token, only: :result
  before_filter :find_payment_deposit_by_token, only: [ :fail, :success, :result ]

  def new
    @interkassa_deposit = Payment::InterkassaDeposit.new
    respond_with(@interkassa_deposit) do |format|
      format.html
      format.js
    end
  end

  def create
    @interkassa_deposit = Payment::InterkassaDeposit.new(params[:payment_interkassa_deposit])
    @interkassa_deposit.user = current_user
    @interkassa_deposit.save

    respond_with(@interkassa_deposit) do |format|
      format.js
    end
  end

  # POST www.interkassa.com Interaction Url
  def result
    if interkassa.prerequest? # Pre-request to check that your site is available
      if @interkassa_deposit
        render text: 'YES', status: 200
      else
        render text: "error no payment", status: 500
      end
    elsif interkassa.valid_payment? # Payment callback
      if @interkassa_deposit
        if interkassa.success?
          @interkassa_deposit.amount        = interkassa.params[:am].to_money(@interkassa_deposit.currency)
          @interkassa_deposit.refund_amount = interkassa.params[:co_rfn].to_money(@interkassa_deposit.currency)
          @interkassa_deposit.finish!(interkassa.params)
        end
        render text: "Success", status: 200
      else
        Rails.logger.debug("Interkassa payment error!")
        render text: "failure", status: 200
      end
    else # Payment invalid
      raise InterkassaAcceptor::InvalidTransaction
    end
  end

  def success
    respond_with(@interkassa_deposit) do |format|
      format.html { redirect_to edit_firm_path(current_firm, anchor: 'monetize-purse'), notice: 'Платеж успешно проведен' }
    end
  end

  def pending
    @interkassa_deposit.pending!(interkassa.params) if @interkassa_deposit.present?
    respond_with(@interkassa_deposit) do |format|
      format.html { redirect_to edit_firm_path(current_firm, anchor: 'monetize-purse'), notice: 'Платеж в режиме ожидания оплаты' }
    end
  end

  def fail
    @interkassa_deposit.close!(interkassa.params) if @interkassa_deposit.present?
    respond_with(@interkassa_deposit) do |format|
      format.html { redirect_to edit_firm_path(current_firm, anchor: 'monetize-purse'), notice: 'Платеж отменен' }
    end
  end

  private

  def find_payment_deposit_by_token
    @interkassa_deposit = Payment::InterkassaDeposit.pending_or_canceled.find_by_token(interkassa.params[:pm_no])
  end
end
