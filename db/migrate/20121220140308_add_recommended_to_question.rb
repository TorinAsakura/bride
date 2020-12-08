class AddRecommendedToQuestion < ActiveRecord::Migration
  def change
    add_column :questions, :recommended, :boolean, :default => false
  end
end
