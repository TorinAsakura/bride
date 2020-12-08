class CreateWeddingInvites < ActiveRecord::Migration
  def change
    create_table :wedding_invites do |t|
      t.references :client
      t.integer :couple_id

      t.timestamps
    end
    add_index :wedding_invites, :client_id
  end
end