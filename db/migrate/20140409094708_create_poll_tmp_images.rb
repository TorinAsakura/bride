class CreatePollTmpImages < ActiveRecord::Migration
  def change
    create_table :poll_tmp_images do |t|
      t.string :image, null: false
      t.integer :client_id
      t.timestamps
    end
  end
end
