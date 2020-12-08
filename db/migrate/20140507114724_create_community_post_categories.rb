class CreateCommunityPostCategories < ActiveRecord::Migration
  def change
    create_table :community_post_categories do |t|
      t.references :community
      t.string :name

      t.timestamps
    end
    add_index :community_post_categories, :community_id
  end
end
