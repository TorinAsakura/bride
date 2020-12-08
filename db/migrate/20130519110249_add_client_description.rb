class AddClientDescription < ActiveRecord::Migration
  def change
  	add_column :clients, :description, :text
  end
end
