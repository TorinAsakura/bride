class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :brand, :null => false
      t.string :inn, :null => false
      t.string :ogrn, :null => false
      t.string :legal_address, :null => false
      t.string :bank, :null => false
      t.string :bik, :null => false
      t.string :rs, :null => false
      t.string :ks, :null => false
    end
  end
end
