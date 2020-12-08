class RemoveExtnameColumnFromCommunities < ActiveRecord::Migration
  def up
    remove_column :communities, :extname
  end

  def down
    add_column :communities, :extname, :string
  end
end
