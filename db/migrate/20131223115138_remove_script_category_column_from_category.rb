class RemoveScriptCategoryColumnFromCategory < ActiveRecord::Migration
  def up
    remove_column :scripts, :script_category_id
  end

  def down
    add_column :scripts, :script_category_id, :integer
  end
end
