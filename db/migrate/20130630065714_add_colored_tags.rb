class AddColoredTags < ActiveRecord::Migration
  def change
  	create_table :color_tags do |t|
  		t.string :name
  		t.string :color
    end
  end
end
