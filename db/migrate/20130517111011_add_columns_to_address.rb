class AddColumnsToAddress < ActiveRecord::Migration
  def change
  	add_column :addresses, :city_id, :integer
  	add_column :addresses, :email, :string
  	add_column :addresses, :icq, :string
  	add_column :addresses, :skype, :string
  	add_column :addresses, :mailru, :string
  	add_column :addresses, :site, :string
  end
end
