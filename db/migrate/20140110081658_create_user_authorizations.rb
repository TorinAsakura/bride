class CreateUserAuthorizations < ActiveRecord::Migration
  def change
    create_table :user_authorizations do |t|
      t.string :provider
      t.string :uid
      t.string :token
      t.string :secret
      t.hstore :data
      t.belongs_to :user
      t.boolean :primary, default: false

      t.timestamps
    end
    add_index :user_authorizations, :user_id
  end
end
