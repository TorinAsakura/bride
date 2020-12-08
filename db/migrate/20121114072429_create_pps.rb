class CreatePps < ActiveRecord::Migration
  def change
    create_table :pps do |t|
      t.string :name, :null => false
      t.string :surname, :null => false
      t.string :middlename
      t.string :passport, :null => false
      t.string :passport_issued, :null => false
      t.date :passport_date, :null => false
    end
  end
end
