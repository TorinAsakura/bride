class CreateIes < ActiveRecord::Migration
  def change
    create_table :ies do |t|
      t.string :brand, :null => false
      t.string :inn, :null => false
      t.string :ogrnip, :null => false
      t.string :legal_address, :null => false
      t.string :bank
      t.string :bik
      t.string :rs
      t.string :ks
    end
  end
end
