class DeleteAddressFromFirms < ActiveRecord::Migration
  def up
    remove_column :firms, :address
    remove_column :firms, :contact_name
    remove_column :firms, :phone
  end

  def down
    add_column :firms, :phone, :string
    add_column :firms, :contact_name, :string
    add_column :firms, :address, :string
  end
end
