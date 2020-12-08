class AddCardServiceToFirms < ActiveRecord::Migration
  def up
    add_column :firms, :card_service_id, :integer
  end

  def down
    remove_column :firms, :card_service_id
  end
end
