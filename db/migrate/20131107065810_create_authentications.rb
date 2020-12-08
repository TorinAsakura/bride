class CreateAuthentications < ActiveRecord::Migration
  def up
    create_table :social_accounts do |t|
      t.integer :user_id, :null => false
      t.string  :type, :null => false
      t.string  :uid, :null => false
      t.text    :credentials
    end

    add_index :social_accounts, :uid
    add_index :social_accounts, :user_id

    change_table :users do |t|
      t.remove :provider, :uid
    end

    change_table :clients do |t|
      t.remove :vk, :fb, :tw, :mailru
    end

    change_column_null :users, :email, true
  end

  def down
    drop_table :social_accounts

    change_table :users do |t|
      t.string   "provider"
      t.string   "uid"
    end

    change_table :clients do |t|
      t.string   "vk"
      t.string   "fb"
      t.string   "tw"
      t.string   "mailru"
    end

#    change_column_null :users, :email, false
  end
end
