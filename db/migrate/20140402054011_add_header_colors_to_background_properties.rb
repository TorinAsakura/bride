class AddHeaderColorsToBackgroundProperties < ActiveRecord::Migration
  def change
    add_column :background_properties, :header_color, :string, default: '#4D4D4D'
    add_column :background_properties, :header_date_color, :string, default: '#C84563'
  end
end
