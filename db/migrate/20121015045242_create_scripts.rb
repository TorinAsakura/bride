class CreateScripts < ActiveRecord::Migration
  def change
    create_table :scripts do |t|
      t.string :name
      t.references :script_category
      t.string :description

      t.timestamps
    end
    add_index :scripts, :script_category_id
  end
end
