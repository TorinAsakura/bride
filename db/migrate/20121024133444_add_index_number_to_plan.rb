class AddIndexNumberToPlan < ActiveRecord::Migration
  def up
    add_column :plans, :index_number, :integer
  end

  def down
    remove_column :plans, :index_number
  end
end
