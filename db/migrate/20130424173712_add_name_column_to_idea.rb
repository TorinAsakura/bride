class AddNameColumnToIdea < ActiveRecord::Migration
  def change
    add_column :ideas, :name, :string
  end
end
