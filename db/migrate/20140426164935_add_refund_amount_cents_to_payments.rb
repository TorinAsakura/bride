class AddRefundAmountCentsToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :refund_amount_cents, :integer, default: 0
  end
end
