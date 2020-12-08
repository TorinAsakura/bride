class OldTagsClean < ActiveRecord::Migration
  def up
		remove_column :ideas, :delta
		drop_table :tag_categories
  end

  def down
  	add_column :ideas, :delta, :boolean, :default => true, :null => false
  	create_table :tag_categories do |t|
      t.string :name

      t.timestamps
    end
  end


end
