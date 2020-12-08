class CreateSeatingSeats < ActiveRecord::Migration
  def change
    create_table :seating_seats do |t|
      t.belongs_to :table
      t.references :guest, polymorphic: true
      t.string :side
      t.string :gender
      t.integer :position

      t.timestamps
    end

    add_index :seating_seats, :table_id
    add_index :seating_seats, [:guest_id, :guest_type]
    add_index :seating_seats, :position
  end
end
