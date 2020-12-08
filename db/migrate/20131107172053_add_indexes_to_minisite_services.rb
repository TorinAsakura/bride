class AddIndexesToMinisiteServices < ActiveRecord::Migration
  def change
    add_index :wedding_calcs, :site_id
    add_index :seating_plans, :site_id
    add_index :guests,        :site_id
    add_index :wishlists,     :site_id
    add_index :programms,     :site_id
  end
end
