class CreateWeddingCalcs < ActiveRecord::Migration
  def change
    create_table :wedding_calcs do |t|
      t.integer :wedding_id
      t.text    :categories

      t.timestamps
    end

    add_index :wedding_calcs, :wedding_id
  end
end
