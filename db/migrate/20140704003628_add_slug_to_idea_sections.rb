class AddSlugToIdeaSections < ActiveRecord::Migration
  def change
    add_column :idea_sections, :slug, :string
    add_index :idea_sections, :slug, unique: true
  end
end
