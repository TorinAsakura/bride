class AddVkToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :vk, :string
  end
end
