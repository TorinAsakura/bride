class Admin::PursePaymentsController < AdminController
  layout 'admin_application'
  respond_to :js, :html
  before_filter :set_purse
  before_filter :set_purse_payments

  def index
    @purse_payments = @purse_payments.send(@scope)
    @purse_payments = Kaminari.paginate_array(@purse_payments).page(params[:page])
    respond_with(@purse_payments)
  end

  def show
    @purse_payment = @purse_payments.find(params[:id])
    respond_with(@purse_payment)
  end

  private
  def set_purse
    @purse = Purse.find(params[:purse_id]) if params[:purse_id].present?
  end

  def set_purse_payments
    @purse_payments = (@purse.present? ? @purse.purse_payments.ordered : PursePayment.ordered)
    scope_names = %w(all pending canceled completed systemic)
    @scope = (scope = params[:scope]).present? && scope_names.include?(scope) && scope || 'all'
    @scopes = scope_names.map{|s| {name: s, scope: s, count: @purse_payments.send(s).count}}
  end
end
