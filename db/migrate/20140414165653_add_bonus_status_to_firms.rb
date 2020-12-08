class AddBonusStatusToFirms < ActiveRecord::Migration
  def change
    add_column :firms, :bonus_status, :integer, default: 0
    add_index :firms, :bonus_status
  end
end
