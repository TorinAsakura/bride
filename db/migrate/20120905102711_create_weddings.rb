class CreateWeddings < ActiveRecord::Migration
  def change
    create_table :weddings do |t|
      t.date :wedding_date
    end
  end
end
