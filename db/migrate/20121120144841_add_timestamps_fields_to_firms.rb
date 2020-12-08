class AddTimestampsFieldsToFirms < ActiveRecord::Migration
  def up
    change_table :firms do |t|
      t.timestamps
    end
  end

  def down
    remove_column :firms, :created_at
    remove_column :firms, :updated_at
  end
end
