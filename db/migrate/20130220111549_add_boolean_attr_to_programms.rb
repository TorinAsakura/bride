class AddBooleanAttrToProgramms < ActiveRecord::Migration
  def change
    add_column :programms, :second_day, :boolean
  end
end
