class CreateCommunityCategories < ActiveRecord::Migration
  def change
    create_table :community_categories do |t|
      t.string :title
      t.text :description
      t.string :avatar

      t.timestamps
    end
  end
end
