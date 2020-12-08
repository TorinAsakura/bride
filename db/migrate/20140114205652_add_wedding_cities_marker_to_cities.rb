class AddWeddingCitiesMarkerToCities < ActiveRecord::Migration
  def change
    add_column :cities, :wedding_city, :boolean, default: false
    puts 'migration "add wedding cities marker to cities" done'
  end
end
