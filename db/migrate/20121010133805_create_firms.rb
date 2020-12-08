class CreateFirms < ActiveRecord::Migration
  def change
    create_table :firms do |t|
      t.string :name
      t.string :country
      t.string :region
      t.string :city
      t.string :phone
      t.string :address
      t.string :email
      t.string :logo

     # t.timestamps
    end
  end
end
