class AddCityIdToUser < ActiveRecord::Migration
  def up
    change_table :users do |t|
       t.references :city
    end
    add_index(:users, :city_id)
  end

  def down
    remove_index(:users, :city_id)
    
    change_table :users do |t|
       t.remove_references :city
    end
  end
end
