class CreateBonusSeasonalFactors < ActiveRecord::Migration
  def change
    create_table :bonus_seasonal_factors do |t|
      t.belongs_to :service
      t.integer :month
      t.integer :discount, default: 0

      t.timestamps
    end
    add_index :bonus_seasonal_factors, :service_id
  end
end
