class CreateComplaints < ActiveRecord::Migration
  def change
    create_table :complaints do |t|
      t.references :user
      t.references :pretension, :polymorphic => true
      t.text       :content

      t.timestamps
    end
    add_index :complaints, :user_id
    add_index :complaints, [:pretension_id, :pretension_type]
  end
end
