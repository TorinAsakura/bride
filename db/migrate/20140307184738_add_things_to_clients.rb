class AddThingsToClients < ActiveRecord::Migration
  def change
    add_column :clients, :thing_in_life, :string
    add_column :clients, :thing_in_humans, :string
  end
end
