class CreateBonusCityRatios < ActiveRecord::Migration
  def change
    create_table :bonus_city_ratios do |t|
      t.belongs_to :service
      t.belongs_to :city
      t.integer :percent, default: 0

      t.timestamps
    end
    add_index :bonus_city_ratios, :service_id
    add_index :bonus_city_ratios, :city_id
  end
end
