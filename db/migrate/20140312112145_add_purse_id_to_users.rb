class PurseStub < ActiveRecord::Base
  set_table_name :purses
  monetize :amount_cents, as: :amount
  attr_accessible :amount, :deposit_discount
end

class RoleStub < ActiveRecord::Base
  set_table_name :roles

end

class UsersRoleStub < ActiveRecord::Base
  set_table_name :users_roles
  belongs_to :user, class_name: 'UserStub', foreign_key: :user_id
  belongs_to :role, class_name: 'RoleStub', foreign_key: :role_id
end

class UserStub < ActiveRecord::Base
  set_table_name :users
  belongs_to :purse, class_name: 'PurseStub', foreign_key: :purse_id
  has_many :users_roles, class_name: 'UsersRoleStub', source: :user, foreign_key: :user_id
  has_many :roles, class_name: 'RoleStub', through: :users_roles, source: :role

  def create_purse
    self.purse_id = PurseStub.create!(amount:0, deposit_discount: deposit_discount).id if self.purse.blank?
    self.save!
  end

  def deposit_discount
    self.roles.map(&:name).include?(:dealer) ? 90 : 0
  end
end

class AddPurseIdToUsers < ActiveRecord::Migration
  def migrate(direction)
    super
    UserStub.find_each(&:create_purse) if direction == :up
  end

  def change
    add_column :users, :purse_id, :integer
    add_index :users, :purse_id
  end
end
