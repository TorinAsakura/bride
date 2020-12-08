class AddValueToSpecifications < ActiveRecord::Migration
  def up
    add_column :specifications, :value, :string
    remove_column :specifications, :icon
    add_column :specifications, :icon_id, :integer
  end

  def down
    remove_column :specifications, :value
    add_column :specifications, :icon, :string
    remove_column :specifications, :icon_id
  end
end
