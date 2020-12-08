class RemoveCityIdColumnFromWedding < ActiveRecord::Migration
  def up
    remove_index  :weddings, :city_id
    remove_column :weddings, :city_id
  end

  def down
    add_column :weddings, :city_id, :integer
    add_index  :weddings, :city_id
  end
end
