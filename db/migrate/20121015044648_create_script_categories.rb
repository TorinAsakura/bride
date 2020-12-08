class CreateScriptCategories < ActiveRecord::Migration
  def change
    create_table :script_categories do |t|
      t.string :name

      t.timestamps
    end
  end
end
