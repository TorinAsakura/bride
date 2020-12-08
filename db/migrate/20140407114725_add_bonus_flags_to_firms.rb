class AddBonusFlagsToFirms < ActiveRecord::Migration
  def change
    add_column :firms, :bonus_pro_at, :date
    add_index :firms, :bonus_pro_at
    add_column :firms, :bonus_vip_at, :date
    add_index :firms, :bonus_vip_at
    add_column :firms, :bonus_color_at, :date
    add_index :firms, :bonus_color_at
    add_column :firms, :bonus_high_in_at, :datetime
    add_index :firms, :bonus_high_in_at
  end
end
