class DropScroptCategoryTable < ActiveRecord::Migration
  def up
    drop_table :script_categories
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
