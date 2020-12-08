class AddMobilePhoneToAddress < ActiveRecord::Migration
  def change
    add_column :addresses, :mobile_phone, :string
  end
end
