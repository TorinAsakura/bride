class CreateBonusLoyalties < ActiveRecord::Migration
  def change
    create_table :bonus_loyalties do |t|
      t.belongs_to :service
      t.integer :years_count
      t.integer :discount

      t.timestamps
    end
    add_index :bonus_loyalties, :service_id
  end
end
