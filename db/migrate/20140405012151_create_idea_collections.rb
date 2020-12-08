class CreateIdeaCollections < ActiveRecord::Migration
  def change
    create_table :idea_collections do |t|
      t.string :name
      t.timestamps
    end

    change_table :idea_categories do |t|
      t.belongs_to :idea_collection
    end
  end
end
