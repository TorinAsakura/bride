class AddColumnWeddingDateToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wedding_date, :date
  end
end