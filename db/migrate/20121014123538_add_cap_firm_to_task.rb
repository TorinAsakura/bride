class AddCapFirmToTask < ActiveRecord::Migration
  def change
    add_column :tasks, :cap_firm, :string
  end
end
