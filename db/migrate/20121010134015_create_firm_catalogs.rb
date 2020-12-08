class CreateFirmCatalogs < ActiveRecord::Migration
  def change
    create_table :firm_catalogs do |t|
      t.string :name

     # t.timestamps
    end
  end
end
