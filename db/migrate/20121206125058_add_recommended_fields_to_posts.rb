class AddRecommendedFieldsToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :recommend, :boolean, :default => false, :null => false
    add_column :posts, :accepted, :boolean, :default => false, :null => false
  end
end
