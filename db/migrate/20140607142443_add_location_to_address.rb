class AddLocationToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :location, :string
  end
end
