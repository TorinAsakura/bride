class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :title
      t.text :description
      t.date :date_from
      t.date :date_to
      t.boolean :is_private
      t.references :wedding
      t.references :event_category
      t.boolean :completed

      t.timestamps
    end
    add_index :events, :event_category_id
    add_index :events, :wedding_id
    add_index :events, :date_from
  end
end
