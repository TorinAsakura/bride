class ChangePayments < ActiveRecord::Migration
  def up
    drop_table :payments
    create_table :payments do |t|
      t.string :type
      t.belongs_to :user
      t.integer :amount_cents, default: 0, null: false
      t.string :currency, default: 'RUB'
      t.string :token
      t.string :identifier
      t.string :payer_id
      t.string :state

      t.timestamps
    end
    add_index :payments, :type
    add_index :payments, :user_id
    add_index :payments, :currency
    add_index :payments, :identifier
    add_index :payments, :state
  end

  def down
    drop_table :payments
    create_table :payments do |t|
      t.integer :firm_id, null: false, default: 0
      t.boolean :approved, null: false, default: false
      t.string :direction, null: false
      t.references :firm, null: false

      t.timestamps
    end
    add_index :payments, :firm_id
  end
end
