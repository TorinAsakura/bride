class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :name
      t.string :address
      t.string :phone
      t.string :contact_name
      t.boolean :base, :null => false, :default => true
      t.references :firm

      t.timestamps
    end
    add_index :addresses, :firm_id
  end
end
