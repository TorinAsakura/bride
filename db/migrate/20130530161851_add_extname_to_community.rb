class AddExtnameToCommunity < ActiveRecord::Migration
  def change
    add_column :communities, :extname, :string
  end
end
