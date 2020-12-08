class RemoveEmailFromFirms < ActiveRecord::Migration
  def up
    remove_column :firms, :email
  end

  def down
    add_column	  :firms, :email, :string
  end
end
