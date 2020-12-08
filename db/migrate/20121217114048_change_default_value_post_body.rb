class ChangeDefaultValuePostBody < ActiveRecord::Migration
  def up
    change_column :posts, :body, :text, :default => ""
  end

  def down
    change_column :posts, :body, :text
  end
end
