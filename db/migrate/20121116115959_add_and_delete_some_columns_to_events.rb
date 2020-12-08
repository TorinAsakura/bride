class AddAndDeleteSomeColumnsToEvents < ActiveRecord::Migration
  def up
    change_table :events do |t|
      #t.change :column_name, :column_type, {options}
      t.remove :event_category_id
      t.remove :is_private
      t.remove :is_freeze
      
      t.rename :title, :name
      
      t.references :firm_catalog
      t.references :servise
      t.references :firm
      
      t.string :type_task
    end
  end
  
  def down
    change_table :events do |t|
      #t.change :column_name, :column_type, {options}
      t.integer :event_category_id
      t.integer :is_private
      t.integer :is_freeze
      
      t.rename :name, :title
      
      t.remove_references :firm_catalog
      t.remove_references :servise
      t.remove_references :firm
      
      t.remove :type_task
    end  
    
    add_index :events, :event_category_id
  end
end
