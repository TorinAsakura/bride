class AddRatingToCityFirm < ActiveRecord::Migration
  def change
    add_column :city_firms, :rating, :integer
  end
end
