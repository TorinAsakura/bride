class AddIsPerformerToUser < ActiveRecord::Migration
  def up
    change_table :users do |t|
      t.boolean :is_performer, :default => false
    end
  end
  def down
    change_table :users do |t|
      t.remove :is_performer
    end
  end
end
