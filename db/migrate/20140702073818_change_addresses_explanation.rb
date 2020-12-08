class ChangeAddressesExplanation < ActiveRecord::Migration
  def change
    change_column :addresses, :explanation, :text
  end
end
