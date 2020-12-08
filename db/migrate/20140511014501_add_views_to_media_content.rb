class AddViewsToMediaContent < ActiveRecord::Migration
  def change
    add_column :media_contents, :views, :integer, default: 0
  end
end
