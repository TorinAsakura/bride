class AddBusinessTypesToFirms < ActiveRecord::Migration
  def change
    add_column :firms, :business_id, :integer
    add_column :firms, :business_type, :string
  end
end
