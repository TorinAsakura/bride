class AddMariralStatusToClients < ActiveRecord::Migration
  def change
    add_column :clients, :marital_status, :string
  end
end
