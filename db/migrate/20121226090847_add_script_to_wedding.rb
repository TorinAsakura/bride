class AddScriptToWedding < ActiveRecord::Migration
  def change
    add_column :weddings, :script_id, :integer, :nil => false
    add_index :weddings, :script_id
  end
end
