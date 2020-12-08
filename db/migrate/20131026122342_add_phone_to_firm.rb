class AddPhoneToFirm < ActiveRecord::Migration
  def change
    add_column :firms, :phone, :string
  end
end
