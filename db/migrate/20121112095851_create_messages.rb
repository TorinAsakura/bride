class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.references :user, :recipient
      t.string :subject
      t.text :body
      t.boolean :read, :null => false, :default => false
      t.timestamps
    end
    add_index :messages, :user_id
    add_index :messages, :recipient_id
  end
end
