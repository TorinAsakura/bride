class CreateBanners < ActiveRecord::Migration
  def up
    create_table :banners do |t|
      t.string :image
      t.string :title
      t.string :link
      t.text :description
      t.boolean :for_guests
      t.boolean :for_users
      t.boolean :for_firms
      t.integer :banner_type, default: 0

      t.timestamps
    end
  end

  def down
    drop_table :banners
  end
end
