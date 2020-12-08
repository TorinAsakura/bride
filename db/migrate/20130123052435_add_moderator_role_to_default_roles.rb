# encoding: utf-8

class AddModeratorRoleToDefaultRoles < ActiveRecord::Migration
  def up
    Role.create!(name: 'moderator', title: 'Модератор')
  end

  def down
    r = Role.find_by_name('moderator')
    r.destroy if r
  end

end
