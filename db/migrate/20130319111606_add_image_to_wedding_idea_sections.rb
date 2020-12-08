class AddImageToWeddingIdeaSections < ActiveRecord::Migration
  def change
    add_column :wedding_idea_sections, :image, :string
  end
end
