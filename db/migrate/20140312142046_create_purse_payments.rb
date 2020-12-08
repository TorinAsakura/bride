class CreatePursePayments < ActiveRecord::Migration
  def change
    create_table :purse_payments do |t|
      t.string :type
      t.belongs_to :source_purse
      t.belongs_to :purse
      t.belongs_to :source_payment
      t.references :target, polymorphic: true
      t.string :name
      t.text :description
      t.integer :amount_cents, default: 0, null: false
      t.string :state
      t.text :params

      t.timestamps
    end
    add_index :purse_payments, :source_purse_id
    add_index :purse_payments, :purse_id
    add_index :purse_payments, :source_payment_id
    add_index :purse_payments, :target_id
    add_index :purse_payments, :target_type
  end
end
