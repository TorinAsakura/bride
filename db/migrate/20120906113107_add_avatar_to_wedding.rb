class AddAvatarToWedding < ActiveRecord::Migration
  def change
    add_column :weddings, :avatar, :string
  end
end
