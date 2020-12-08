class CreateSeatingTables < ActiveRecord::Migration
  def change
    create_table :seating_tables do |t|
      t.belongs_to :plan
      t.string :form
      t.string :title
      t.integer :height
      t.integer :width
      t.integer :deg
      t.integer :left_position
      t.integer :top_position

      t.timestamps
    end
    add_index :seating_tables, :plan_id
  end
end
