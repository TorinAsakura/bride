# encoding: utf-8
class AddAdminRoleToDefaultRoles < ActiveRecord::Migration
  def up
    Role.create!(name: 'admin', title: 'Aдминистратор')
  end

  def down
    r = Role.find_by_name('admin')
    r.destroy if r
  end
end
