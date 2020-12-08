class AddDescriptionToFirm < ActiveRecord::Migration
  def change
    add_column :firms, :description, :text
  end
end
