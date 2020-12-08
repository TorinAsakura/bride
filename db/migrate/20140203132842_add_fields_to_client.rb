class AddFieldsToClient < ActiveRecord::Migration
  def change
    add_column :clients, :visibility, :string
    add_column :clients, :country_id, :integer
    add_column :clients, :children, :string
    add_column :clients, :string, :string
    add_column :clients, :alcohol_attitude, :string
    add_column :clients, :smoking_attitude, :string
  end
end
