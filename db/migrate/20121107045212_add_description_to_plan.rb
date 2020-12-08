class AddDescriptionToPlan < ActiveRecord::Migration
  def up
    add_column :plans, :description, :text
  end
  def down
    remove_column :plans, :description
  end
end
