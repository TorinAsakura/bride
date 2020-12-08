class AddCommunityCategoryRefToCommunities < ActiveRecord::Migration
  def change
    add_column :communities, :community_category_id, :integer
    add_index  :communities, :community_category_id
  end
end
