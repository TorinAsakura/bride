class AddPositionColumnToCommunityCategories < ActiveRecord::Migration
  def change
    add_column :community_categories, :position, :integer
  end
end
