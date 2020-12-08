class ChangeTypeDescription < ActiveRecord::Migration
  def up
    change_column :tasks, :description, :text
    change_column :scripts, :description, :text
  end

  def down
    change_column :tasks, :description, :string
    change_column :scripts, :description, :string
  end
end
