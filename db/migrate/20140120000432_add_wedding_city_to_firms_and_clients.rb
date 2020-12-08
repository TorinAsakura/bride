class AddWeddingCityToFirmsAndClients < ActiveRecord::Migration
  def change
    add_column :firms, :wedding_city_id, :integer, default: nil
    add_column :clients, :wedding_city_id, :integer, default: nil

    add_index :firms, :wedding_city_id
    add_index :clients, :wedding_city_id

    puts 'migration "add wedding city to firms and cities" done'
  end
end
