class UserSignInForm
  include Virtus.model

  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attribute :login, String
  attribute :password, String

  validates :login, :presence => true, :format => {:with => Devise.email_regexp }
  validates :password, :presence => true, :format => {:with => User.password_format }
  validate :login_exist
  validate :correct_password

  def self.i18n_scope
    :activerecord
  end

  def persisted?
    false
  end

  def login_exist
    errors.add(:login, :not_present) if !user_found?(login)
  end

  def correct_password
    if user_found?(login)
      user = User.find_by_email(login)
      if !user.valid_password?(password)
        errors.add(:password, :wrong)
      end
    end
  end

  private
  def user_found?(login)
    !!User.find_by_email(login)
  end
end
