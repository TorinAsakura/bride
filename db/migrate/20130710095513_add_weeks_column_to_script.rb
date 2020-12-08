class AddWeeksColumnToScript < ActiveRecord::Migration
  def change
    add_column :scripts, :weeks, :integer
  end
end
