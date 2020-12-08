class AddStatusToFirm < ActiveRecord::Migration
  def change
    add_column :firms, :status, :string
  end
end
