class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :name
      t.references :tag_category

      t.timestamps
    end
  end
end
