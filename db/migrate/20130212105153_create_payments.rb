class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :amount, null: false, default: 0
      t.boolean :approved, null: false, default: false
      t.string :direction, null: false
      t.references :firm, null: false

      t.timestamps
    end
    add_index :payments, :firm_id
  end
end
