class AddContactsToFirms < ActiveRecord::Migration
  def change
    add_column :firms, :contact_name, :string
    add_column :firms, :skype, :string
    add_column :firms, :website, :string
  end
end
