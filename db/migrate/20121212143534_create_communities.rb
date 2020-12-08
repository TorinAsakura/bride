class CreateCommunities < ActiveRecord::Migration
  def change
    create_table :communities do |t|
      t.string :avatar
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
