# encoding: utf-8

class AddUserAndFirmRolesToDefaultRoles < ActiveRecord::Migration
  def up
    Role.create!(name: 'user', title: 'Обычный пользователь')
    Role.create!(name: 'firm', title: 'Фирма')
  end

  def down
    Role.destroy_all(:name => ['user', 'firm'])
  end

end
