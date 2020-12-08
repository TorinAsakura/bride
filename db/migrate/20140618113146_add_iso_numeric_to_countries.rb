class AddIsoNumericToCountries < ActiveRecord::Migration
  def change
    add_column :countries, :iso_numeric, :string
  end
end
