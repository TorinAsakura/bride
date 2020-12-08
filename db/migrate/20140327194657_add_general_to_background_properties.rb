class AddGeneralToBackgroundProperties < ActiveRecord::Migration
  def change
    add_column :background_properties, :general, :boolean, default: false
  end
end
