class AddPriorityToIdeaSections < ActiveRecord::Migration
  def change
    add_column :idea_sections, :priority, :integer, default: 0
  end
end
