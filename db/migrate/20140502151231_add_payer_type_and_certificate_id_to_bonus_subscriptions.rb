class AddPayerTypeAndCertificateIdToBonusSubscriptions < ActiveRecord::Migration
  def change
    add_column :bonus_subscriptions, :payer_type, :string, default: 'User'
    add_column :bonus_subscriptions, :certificate_id, :integer

    add_index :bonus_subscriptions, [:payer_id, :payer_type], name: :bonus_subscriptions_payer_index
    add_index :bonus_subscriptions, :certificate_id
  end
end
