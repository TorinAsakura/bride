class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name
      t.string :title
      t.text   :content
      t.boolean :system, :null => false, :default => false
      t.boolean :active, :null => false, :default => true
      t.references :site
      t.boolean :main, :default => false, :null => false
      t.timestamps
    end
    add_index :pages, [:name, :site_id], :unique => true
  end
end
