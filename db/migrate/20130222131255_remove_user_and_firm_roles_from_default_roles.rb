# encoding: utf-8

class RemoveUserAndFirmRolesFromDefaultRoles < ActiveRecord::Migration
  def up
    Role.destroy_all(:name => ['user', 'firm'])
  end

  def down
    Role.create!(name: 'user', title: 'Обычный пользователь')
    Role.create!(name: 'firm', title: 'Фирма')
  end
end
