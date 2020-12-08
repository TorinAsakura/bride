class AddBalanceToFirms < ActiveRecord::Migration
  def change
    add_column :firms, :balance, :integer, :null => false, :default => 0
  end
end
