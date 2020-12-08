class AddDeletedAtToCityFirms < ActiveRecord::Migration
  def change
    add_column :city_firms, :deleted_at, :datetime
  end
end
