class AddIdeaCollectionReferendeToIdeas < ActiveRecord::Migration
  def change
    change_table :ideas do |t|
      t.belongs_to :idea_collection
    end
  end
end
