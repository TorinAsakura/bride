class ChangePostModerateFields < ActiveRecord::Migration
  def up
		remove_column :posts, :status
		remove_column :posts, :recommend
		remove_column :posts, :accepted
		add_column :posts, :status, :integer, :null => false, :default => 0
  end

  def down
  	remove_column :posts, :status
  	add_column :posts, :status, :bool
		add_column :posts, :recommend, :bool
		add_column :posts, :accepted, :bool
  end
end
