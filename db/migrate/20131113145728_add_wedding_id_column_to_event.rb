class AddWeddingIdColumnToEvent < ActiveRecord::Migration
  def change
    add_column :events, :wedding_id, :integer
  end
end
