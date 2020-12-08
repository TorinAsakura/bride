class AddPaymentTypeToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :payment_type, :string
  end
end
