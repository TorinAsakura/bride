class AddSlugToClients < ActiveRecord::Migration
  def change
    add_column :clients, :slug, :string
    add_index :clients, :slug
  end
end
