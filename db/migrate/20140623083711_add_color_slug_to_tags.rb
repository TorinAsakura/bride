class AddColorSlugToTags < ActiveRecord::Migration
  def change
    add_column :tags, :color_slug, :string
  end
end
