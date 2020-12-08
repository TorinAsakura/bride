class AddSlugToFirms < ActiveRecord::Migration
  def change
    add_column :firms, :slug, :string
    add_index :firms, :slug
  end
end
