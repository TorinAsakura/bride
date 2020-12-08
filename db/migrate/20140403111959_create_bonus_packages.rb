class CreateBonusPackages < ActiveRecord::Migration
  def change
    create_table :bonus_packages do |t|
      t.belongs_to :service
      t.integer :months_count
      t.integer :percent, default: 0

      t.timestamps
    end
    add_index :bonus_packages, :service_id
  end
end
