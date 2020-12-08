# encoding: utf-8
class Role < ActiveRecord::Base
  GROOM_GUESTS = %w(groom_witness groom_parent groom_relative groom_friend groom_guest)
  BRIDE_GUESTS = %w(bride_witness bride_parent bride_relative bride_friend bride_guest)

  belongs_to :resource, polymorphic: true

  has_many :users_weddings, through: :users_weddings_roles #TODO rolify error customize base :users
  has_many :weddings,       through: :users_weddings_roles
  has_many :users_weddings_roles

  has_many :users, through: :users_roles, source: :user
  has_many :users_roles
  alias_method :system_users, :users

  attr_accessible :name, :title

  scopify
  acts_as_paranoid

  scope :public_roles, where(name: ['groom', 'bride', 'guest', 'performer'])
  scope :couple_roles, where(name: ['groom', 'bride'])
  scope :guest_roles, where(name: GROOM_GUESTS + BRIDE_GUESTS)

  scope :global_roles, where(name: ['admin', 'moderator'])

  def groom_guest?
    GROOM_GUESTS.include?(self.name)
  end

  def bride_guest?
    BRIDE_GUESTS.include?(self.name)
  end

  def guest_group
     if groom_guest?
       'groom'
     elsif bride_guest?
       'bride'
     end
  end
end
