class AddTextStatusToFirms < ActiveRecord::Migration
  def change
    add_column :firms, :text_status, :string, :limit => 255
  end
end
