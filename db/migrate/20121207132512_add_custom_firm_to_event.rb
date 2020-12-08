class AddCustomFirmToEvent < ActiveRecord::Migration
  def change
    add_column :events, :custom_firm, :string
  end
end
