# encoding: utf-8

class CreateGuestRoles < ActiveRecord::Migration
  
  @@guest_roles = {
    'Свидетели жениха'      => 'groom_witness',
    'Родители жениха'       => 'groom_parent',
    'Родственники жениха'   => 'groom_relative',
    'Друзья жениха'         => 'groom_friend',
    'Другие гости жениха'   => 'groom_guest',
    'Свидетели невесты'     => 'bride_witness',
    'Родители невесты'      => 'bride_parent',
    'Родственники невесты'  => 'bride_relative',
    'Друзья невесты'        => 'bride_friend',
    'Другие гости невесты'  => 'bride_guest'
  }

  def up
    @@guest_roles.each do |title, name|
      Role.create!(name: name, title: title)
    end
  end

  def down
    @@guest_roles.each do |title, name|
      @role = Role.find_by_name!(name)
      @role.destroy
    end
  end
end
