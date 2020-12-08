class UpdateFirmServices < ActiveRecord::Migration
  def up
    change_column :firm_services, :cost, :string
  end
end
