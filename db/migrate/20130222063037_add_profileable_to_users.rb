class AddProfileableToUsers < ActiveRecord::Migration
  def up
    add_column :users, :profileable_id, :integer
    add_column :users, :profileable_type, :string
  end
  def down
    remove_column :users, :profileable_type
    remove_column :users, :profileable_id
  end
end
