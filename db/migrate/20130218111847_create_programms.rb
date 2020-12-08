class CreateProgramms < ActiveRecord::Migration
  def change
    create_table :programms do |t|
      t.string :name
      t.time :time
      t.text :description
      t.integer :wedding_id
      t.integer :user_id

      t.timestamps
    end
  end
end
