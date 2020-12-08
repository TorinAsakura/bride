# encoding: utf-8
class User::Authorization < ActiveRecord::Base
  belongs_to :user
  attr_accessible :primary, :provider, :secret, :token, :uid, :data, :user_id, :expires_at

  validates_uniqueness_of :uid, scope: [:provider]
# validates_uniqueness_of :primary, scope: :user_id

  hstorable(
      {
          email:        lambda {|v| v.to_s},
          username:     lambda {|v| v.to_s},
          name:         lambda {|v| v.to_s},
          first_name:   lambda {|v| v.to_s},
          last_name:    lambda {|v| v.to_s},
          middle_name:  lambda {|v| v.to_s},
          birth_date:   lambda {|v| v.to_s},
          gender:       lambda {|v| v.to_s},
          image:        lambda {|v| v.to_s},
          description:  lambda {|v| v.to_s}
      }, :data
  )

  def fio
    "#{first_name} #{middle_name} #{last_name}".squish
  end

  def self.primary
    where(primary: true).first
  end

  def profile_url
    if %w(facebook google_oauth2).include? provider
      data['link']
    else
      if provider == 'instagram'
        "http://instagram.com/#{username}/" if username
      else
        "http://vk.com/#{data['screen_name']}"
      end
    end
  end
end
