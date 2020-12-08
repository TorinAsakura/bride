class Admin::PursesController < AdminController
  layout 'admin_application'
  respond_to :html

  before_filter :set_purse

  def show
    respond_with(@purse)
  end

  def edit
    respond_with(@purse)
  end

  def update
    @purse.update_attributes(params[:purse])
    redirect_to(action: :show)
  end

  def new_cash_deposit
    @payment = Payment::CashDeposit.new
    respond_with(@purse)
  end

  def cash_deposit
    @payment = Payment::CashDeposit.new(params[:payment_cash_deposit])
    @payment.terms_of_service = '1'
    @payment.user = @purse.user
    @payment.payer_id=current_user.id

    if @payment.save
      @payment.complete!
      redirect_to(action: :show)
    else
      render action: :new_cash_deposit
    end
  end

  def new_admin_deposit
    admin = current_user
    @purse_payment = admin.purse_payment_admin_deposits.build(purse: @purse)
    @purse_payment.name = I18n.t('name', scope: @purse_payment.class.translate_scope)
    @purse_payment.description = I18n.t('description', scope: @purse_payment.class.translate_scope, admin: admin.name)
  end

  def admin_deposit
    admin = current_user
    @purse_payment = admin.purse_payment_admin_deposits.build(params[:purse_payment_admin_deposit])
    @purse_payment.purse = @purse
    if @purse_payment.save
      @purse_payment.complete!
      redirect_to(action: :show)
    else
      render action: :new_admin_deposit
    end
  end

  private
  def set_purse
    @purse = Purse.find params[:id]
  end
end
