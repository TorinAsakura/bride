class AddTagRgbFields < ActiveRecord::Migration
  def change
  	add_column :tags, :red, :integer
  	add_column :tags, :green, :integer
  	add_column :tags, :blue, :integer
  end
end
