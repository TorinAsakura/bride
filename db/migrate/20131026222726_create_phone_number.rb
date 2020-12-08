class CreatePhoneNumber < ActiveRecord::Migration
  def change
    create_table :phone_numbers do |t|
      t.string :phone
      t.integer :address_id

      t.timestamps
    end

    add_index :phone_numbers, :address_id
  end
end
