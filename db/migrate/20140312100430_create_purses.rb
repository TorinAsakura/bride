class CreatePurses < ActiveRecord::Migration
  def change
    create_table :purses do |t|
      t.integer :amount_cents, default: 0, null: false
      t.integer :deposit_discount, default: 0

      t.timestamps
    end
  end
end
