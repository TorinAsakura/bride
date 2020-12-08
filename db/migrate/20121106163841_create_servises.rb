# encoding: utf-8
class CreateServises < ActiveRecord::Migration
  def change
    create_table :servises do |t|
      t.string :name
      t.timestamps
    end
    
    add_column :tasks, :servise_id, :integer
    
    add_index :tasks, :servise_id
    
    3.times.each do |i|
      Servise.create(:name => "Сервис #{i}")
    end
    
  end
end
