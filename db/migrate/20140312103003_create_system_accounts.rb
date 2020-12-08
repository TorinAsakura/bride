# encoding: utf-8
# -*- coding: utf-8 -*-
class PurseStub < ActiveRecord::Base
  set_table_name :purses
  monetize :amount_cents, as: :amount
  attr_accessible :amount
end

class SystemAccountStub < ActiveRecord::Base
  set_table_name :system_accounts
  belongs_to :purse, class_name: 'PurseStub', foreign_key: :purse_id
  attr_accessible :identifier, :name

  before_create :create_purse

  def create_purse
    self.purse = PurseStub.create!(amount:0) if self.purse.blank?
    self.save!
  end
end

class CreateSystemAccounts < ActiveRecord::Migration
  def migrate(direction)
    super
    SystemAccount.create!(identifier: 'svadba', name: 'Системный Счет Svadba.org') if direction == :up
  end

  def change
    create_table :system_accounts do |t|
      t.string :name
      t.string :identifier
      t.belongs_to :purse

      t.timestamps
    end
    add_index :system_accounts, :purse_id
  end
end
