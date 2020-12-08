# encoding: utf-8
class CreateDefaultRoles < ActiveRecord::Migration
  def up
    #жених, невеста, гость, исполнитель
    {'Жених' => 'groom', 'Невеста' => 'bride', 'Гость' => 'guest', 'Исполнитель' => 'performer'}.each do |title, name|
      Role.create!(name: name, title: title)
    end
    Role.all.collect{|r| p r.inspect}

  end

  def down
    Role.destroy_all
  end
end
