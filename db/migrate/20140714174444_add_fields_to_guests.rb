class AddFieldsToGuests < ActiveRecord::Migration
  def change
    add_column :guests, :dowry, :boolean
    add_column :guests, :ceremony, :boolean
    add_column :guests, :banquet, :boolean
    add_column :guests, :user_id, :integer
    add_column :guests, :position, :integer

    add_index  :guests, :banquet
    add_index  :guests, :user_id
    add_index  :guests, :position
    add_index  :guests, [:group, :user_id]
  end
end
