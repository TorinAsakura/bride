class CreateFirmPages < ActiveRecord::Migration
  def change
    create_table :firm_pages do |t|
      t.references :firm
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
