class FirmsHasAndBelongsToManyUsers < ActiveRecord::Migration
  def up
    create_table :firms_users, :id => false do |t|
      t.references :firm, :user
    end
  end

  def down
    drop_table :firms_users
  end
end
