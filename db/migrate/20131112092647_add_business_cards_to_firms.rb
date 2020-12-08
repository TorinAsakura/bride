class AddBusinessCardsToFirms < ActiveRecord::Migration
  def up
    add_column :firms, :business_card_left_block, :integer, default: 0
    add_column :firms, :business_card_right_block, :integer, default: 0
  end

  def down
    remove_column :firms, :business_card_left_block
    remove_column :firms, :business_card_right_block
  end
end
