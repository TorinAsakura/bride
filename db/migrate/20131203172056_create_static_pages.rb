class CreateStaticPages < ActiveRecord::Migration
  def change
    create_table :static_pages do |t|
      t.string :title, default: nil
      t.text :content, default: nil
      t.boolean :is_active, default: false
      t.string :link, default: nil

      t.timestamps
    end

    add_index :static_pages, :link
  end
end
