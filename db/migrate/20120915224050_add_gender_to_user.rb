class AddGenderToUser < ActiveRecord::Migration
  def change
    add_column :users, :gender, :boolean, :default => false # false - женский, true - мужской
  end
end
