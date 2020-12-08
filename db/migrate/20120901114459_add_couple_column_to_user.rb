class AddCoupleColumnToUser < ActiveRecord::Migration
  def change
    add_column :users, :couple_id, :integer, :default => nil
  end
end
