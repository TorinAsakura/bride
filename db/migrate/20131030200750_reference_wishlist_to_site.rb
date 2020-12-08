class ReferenceWishlistToSite < ActiveRecord::Migration
  def up
    remove_column :wishlists, :wedding_id
    add_column :wishlists, :site_id, :integer
  end

  def down
    remove_column :wishlists, :site_id
    add_column :wishlists, :wedding_id, :integer
  end
end
