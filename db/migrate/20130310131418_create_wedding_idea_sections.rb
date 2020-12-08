class CreateWeddingIdeaSections < ActiveRecord::Migration
  def change
    create_table :wedding_idea_sections do |t|
      t.string :name

      t.timestamps
    end
  end
end
