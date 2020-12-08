class AddWeddingIdToUser < ActiveRecord::Migration
  def up
    change_table :users do |t|
       t.references :wedding
       t.remove :wedding_date 
    end
  end
  def down
    change_table :users do |t|
       t.date :wedding_date 
       t.remove_references :wedding
    end
  end
end
