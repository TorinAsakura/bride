class AddServiceToTaskAndEvent < ActiveRecord::Migration
  def up
    add_column :tasks, :service, :string
    add_column :events, :service, :string
    
    remove_column :tasks, :servise_id
    remove_column :events, :servise_id
  end

  def down
    add_column :events, :servise_id, :integer
    add_column :tasks, :servise_id, :integer
    
    add_index :tasks, :servise_id
#     add_index :events, :servise_id
    
    remove_column :events, :service
    remove_column :tasks, :service
  end
end
