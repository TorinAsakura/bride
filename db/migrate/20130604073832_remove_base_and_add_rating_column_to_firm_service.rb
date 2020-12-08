class RemoveBaseAndAddRatingColumnToFirmService < ActiveRecord::Migration
  def up
    add_column :firm_services, :raiting, :integer, default: 0, null: false
  	remove_column :firm_services, :base
  end

  def down
  	add_column :firm_services, :base, :boolean, default: false, null: false
    remove_column :firm_services, :raiting
  end
end
