class CreateGuestbooks < ActiveRecord::Migration
  def change
    create_table :guestbooks do |t|
      t.references :site
      t.string :name
      t.text :content

      t.timestamps
    end
    add_index :guestbooks, :site_id
  end
end
