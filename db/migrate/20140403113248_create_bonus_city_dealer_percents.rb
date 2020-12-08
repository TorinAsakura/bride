class CreateBonusCityDealerPercents < ActiveRecord::Migration
  def change
    create_table :bonus_city_dealer_percents do |t|
      t.belongs_to :service
      t.belongs_to :city
      t.integer :percent

      t.timestamps
    end
    add_index :bonus_city_dealer_percents, :service_id
    add_index :bonus_city_dealer_percents, :city_id
  end
end
