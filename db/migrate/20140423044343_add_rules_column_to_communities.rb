class AddRulesColumnToCommunities < ActiveRecord::Migration
  def change
    add_column :communities, :rules, :text
  end
end
