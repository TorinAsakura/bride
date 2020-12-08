class AddFirmsCountToBackgroundProperties < ActiveRecord::Migration
  def change
    add_column :background_properties, :firms_count, :integer, default: 0
    add_index  :background_properties, [:header, :firms_count], name: :index_header_and_firms_count
  end
end
