# encoding: utf-8
class UserRegistrationForm
  include Virtus.model

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_reader :user

  attribute :email, String
  attribute :password, String
  attribute :read, Boolean
  attribute :subscription, Boolean
  attribute :authorization, User::Authorization
  attribute :with_provider, Boolean

  validates :email, :presence => true, :format => {:with => Devise.email_regexp }

  validates :password, :presence => true
  validate :password_lang
  validates :password, :format => {:with => User.password_format}

  validates :read, acceptance: {:accept => true}
  validate :email_uniqueness
  validates_email :email

  delegate :active_for_authentication?, :authenticatable_salt, :to_params, :to => :user

  def self.model_name
    ActiveModel::Name.new(self, nil, "User")
  end

  def self.i18n_scope
    :activerecord
  end

  def persisted?
    false
  end

  def save
    return true if @user

    if valid?
      persist!
      true
    else
      false
    end
  end

  def persist!
    profileable = build_profileable
    @user =  User.new({
                               login: email.downcase,
                               email: email.downcase,
                               password: password,
                               profileable: profileable,
                               subscription: subscription
                           }, :without_protection => true)
    @user.skip_confirmation! if with_provider
    @user.save!
    @user.add_role :moderator, profileable
    @user
  end

  def build_profileable
    nil
  end

  def password_lang
    errors.add(:password, :not_allowed_language) if password_not_right_lang(password)
  end

  def email_uniqueness
    errors.add(:email, :taken) if email.present? && User.where(:email => email.downcase).any?
  end

  private
  def password_not_right_lang(password)
    !!(password =~ /[а-я]/i)
  end
end
