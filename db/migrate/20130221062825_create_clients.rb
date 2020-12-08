class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.integer :couple_id
      t.date	:birthday
      t.integer :wedding_id
      t.integer :type_user
      t.boolean :gender
      t.string	:firstname
      t.string	:lastname
      t.integer :city_id
      t.integer :friends_count
      t.string	:text_status
      t.integer :site_id

      t.timestamps
    end
  end
end
