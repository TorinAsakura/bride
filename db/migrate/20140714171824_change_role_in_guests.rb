class StubGuest < ActiveRecord::Base
  self.table_name = :guests
  belongs_to :role, foreign_key: :role_id
end

class StubRole < ActiveRecord::Base
  self.table_name = :roles
end

class ChangeRoleInGuests < ActiveRecord::Migration
  def up
    add_column :guests, :group, :string
    StubGuest.find_each{|g| g.update_attribute(:group, g.role.groom_guest? ? 'groom' : 'bride')}
    remove_column :guests, :role_id
  end

  def down
    add_column :guests, :role_id, :integer
    StubGuest.find_each{|g| g.update_attribute(:role_id, StubRole.find_by_name("#{g.group}_relative"))}
    remove_column :guests, :group
  end
end
