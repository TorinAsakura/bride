#encoding: utf-8
class UpdateCitiesSchema < ActiveRecord::Migration
  def up
    add_column :countries, :code, :string, :limit => 2

    Country.where(:name => 'Украина').update_all(:code => 'UA')
    Country.where(:name => 'Россия').update_all(:code => 'RU')

    change_table :cities do |t|
      t.float :latitude
      t.float :longitude
      t.integer :geoip_id
      t.boolean :enabled_for_firms, :null => false, :default => false
    end
    add_index :cities, :geoip_id, :unique => true
    add_index :cities, [:latitude, :longitude]

    create_table :ip_ranges do |t|
      t.integer :range_start, :null => false, :limit => 8
      t.integer :range_end, :null => false, :limit => 8
      t.string  :range
      t.integer :city_id
      t.integer :country_id
    end
    add_index :ip_ranges, [:range_start, :range_end]



  end

  def down
    remove_column :countries, :code
    change_table :cities do |t|
      t.remove :latitude, :longitude, :geoip_id, :enabled_for_firms
    end

    drop_table :ip_ranges
  end
end
