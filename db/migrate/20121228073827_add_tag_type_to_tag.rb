class AddTagTypeToTag < ActiveRecord::Migration
  def change
    add_column :tags, :tag_type, :string
    Tag.all.each do |tag|
      tag.tag_type = "article"
      tag.save
    end
  end
end
