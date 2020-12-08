class AddExplanationToAddress < ActiveRecord::Migration
  def up
    add_column :addresses, :explanation, :string
  end

  def down
    remove_column :addresses, :explanation
  end
end
