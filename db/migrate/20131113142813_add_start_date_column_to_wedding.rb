class AddStartDateColumnToWedding < ActiveRecord::Migration
  def change
    add_column :weddings, :start_date, :date
  end
end
