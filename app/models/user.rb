# encoding: utf-8
class User < ActiveRecord::Base
  attr_accessor :read # user's agreement

  scope :unbanned, where(banned: false)
  scope :last_users, ->(count) { order("id DESC").limit(count) }

  include Models::User::City
  include Models::User::MessageStuff
  include Models::User::Friendship
  #include Models::User::SocialAuth

  rolify
  acts_as_voter
  acts_as_commentable
  acts_as_paranoid
  validates_as_paranoid
  validates_uniqueness_of_without_deleted :email, :login

  has_karma(:questions, as: :submitter, weight: 0.5)

  #NOTE uncomment confirmable after work with fake users has gone
  devise :invitable, :database_authenticatable, :registerable, :async,
         :recoverable, :rememberable, :trackable, :confirmable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :vk, :fb,
                  :tw, :mailru, :login, :username, :type_user, :provider, :uid, :profileable_id,
                  :profileable_type, :read, :subscription, :phone

  # for admin
  attr_accessible :banned, :login, :admin_role_ids, as: :admin

  # validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates_email :email
  validates_email :login
  validates :profileable, presence: true
  validates :phone, length: { in: 9..15 }, format: { with: /(?:\+?|\b)[0-9]{10}/i, message: 'Неправильный формат телефона'},
            allow_blank: true

  DEPTH = 2

  belongs_to_with_deleted :profileable, polymorphic: true, with_deleted: true

  has_many :videos, class_name: 'MediaContent', as: :multimedia, conditions: ['media_contents.video = ?', true]
  has_many :audios, class_name: 'MediaContent', as: :multimedia, conditions: ['media_contents.video = ?', false]

  has_many :complaints, as: :pretension

  has_many :invitations, :class_name => 'User', as: :invited_by

  has_many :user_ideas, class_name: 'Idea::UserIdea' do
    def category(category)
      where(idea_user_ideas: {category_id: category.id})
    end
    def idea(idea)
      where(idea_user_ideas: {idea_id: idea.id})
    end
  end
  has_many :ideas, through: :user_ideas

  has_many :albums, as: :resource
  has_many :photos, through: :albums

  has_many :posts, as: :journal

  has_many :admin_roles,
           source: :role,
           through: :users_roles,
           conditions: { roles: { resource_type: nil, resource_id: nil, name: [ :admin, :moderator ] } }
  has_many :users_roles

  has_many :guestbooks

  has_many :authorizations, class_name: 'User::Authorization'

  # Monetize
  belongs_to :purse
  before_create :create_purse
  before_update :update_login, if: :email_changed?

  has_many :bonus_rewards, class_name: 'Bonus::Reward', source: :dealer do
    def filter(referral)
      where(referral_id: referral.id)
    end
  end
  has_many :bonus_reward_transfers, class_name: 'Bonus::RewardTransfer', source: :dealer

  has_many :purse_payment_admin_deposits,        class_name: 'PursePayment::AdminDeposit',       as: :target
  has_many :purse_payment_system_admin_deposits, class_name: 'PursePayment::SystemAdminDeposit', as: :target

  delegate :city_id, to: :client, prefix: true, allow_nil: true
  delegate :city_id, to: :firm, prefix: true, allow_nil: true

  scope :only_clients, -> { where(profileable_type: 'Client')}
  scope :only_firms, -> { where(profileable_type: 'Firm')}

  def wedding_city
    default_city = City.where('name LIKE ?', 'Москва').where(wedding_city: true).first.try(:name)
    if 'client' == self.profileable.class.to_s.downcase
      self.client.wedding_city.try(:name) || default_city
    else
      self.firm.wedding_city.try(:name) || default_city
    end
  end

  def self.password_format
    /^[0-9A-Za-z#\$-%]{6,}$/
  end

  def custom_remove_role name, resource
    delete_role = roles.where(resource_type: resource.class.to_s,
                resource_id: resource.id,
                name: name).first
    delete_users_roles = delete_role.users_roles.where(user_id: id).first
    delete_users_roles.destroy
  end

  def name
    self.client.try(:firstname)||self.firm.try(:name)
  end

  def full_name
    self.profileable.try(:full_name)
  end

  def client
    self.profileable if self.client?
  end

  def firm
    self.profileable if self.firm?
  end

  def is?(user)
    user.eql?(self)
  end
  alias_method :owner?, :is?

  def comment_threads
    Comment.find_comments_for_commentable(profileable_type, profileable_id)
  end

  def root_object
    self
  end

  def can_edit?(user)
   true
  end

  def invited_couple
    User.find(self.couple_id)
  end

  def client?
    self.profileable.is_a?(Client)
  end

  def firm?
    self.profileable.is_a?(Firm)
  end

  # @todo Replace me with normal params binding
  # for polls votes
  def voted? votable
    votable = votable.object if votable.decorated?
    votes = find_votes(votable_id: votable.id, votable_type: votable.class.base_class.name)
    return nil if votes.size == 0
    return votes.first.vote_flag
  end

  def avatar
    if client
      client.avatar
    elsif firm
      firm.logo
    end
  end

  def set_default_city!(ip)
    if city = City.detect_by_ip(ip)
      profileable.set_default_city!(city)
    end
  end

  def authorization_for(provider)
   authorizations.find_by_provider(provider)
  end

  def dealer?
    has_role?(:dealer)
  end

  def admin?
    has_role?(:admin)
  end

  def outstanding_amount_on_reward
    self.bonus_rewards.by_withdrawal.sum(&:amount).to_money - self.bonus_reward_transfers.sum(&:amount).to_money
  end

  private
  def password_complexity
    if password.present? and not password.match(self.class.password_format)
      errors.add :password, "Должен содержать не менее 6 смиволов, может содержать A-Za-z,0-9,(#$-%)"
    end
  end

  def has_social_account?
    authorizations.any?
  end

  def create_purse
    self.purse = Purse.create!(amount:0) if self.purse.blank?
  end

  def update_login
    self.login = self.email if self.login.eql?(self.email_was)
  end
end
