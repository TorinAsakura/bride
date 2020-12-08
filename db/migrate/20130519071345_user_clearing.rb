class UserClearing < ActiveRecord::Migration
  def up  	
  	remove_column :users, :name
  	remove_column :users, :surname
  	remove_column :users, :couple_id
  	remove_column :users, :phone
  	add_column :clients, :phone, :string
  	remove_column :users, :birthday
  	remove_column :users, :gender
  	remove_column :users, :city_id
  	remove_column :users, :wedding_id
  	remove_column :users, :site_id
  	#add_column :clients, :site_id, :integer
  end

  def down  	
  	add_column :users, :name, :string
  	add_column :users, :surname, :string
  	add_column :users, :couple_id, :integer
  	add_column :users, :phone, :string
  	remove_column :clients, :phone
  	add_column :users, :birthday, :date
  	add_column :users, :gender, :boolean
  	add_column :users, :city_id, :integer
  	add_column :users, :wedding_id, :integer
  	add_column :users, :site_id, :integer
  	remove_column :clients, :site_id
  end
end
