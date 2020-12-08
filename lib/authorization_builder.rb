class AuthorizationBuilder
  attr_reader :omnihash, :user, :authorization
  attr_accessor :auth_attribures

  def initialize omnihash, user = nil
    @omnihash = omnihash
    @user     = user
    @auth_attribures = {}
    @authorization = {}
    omniauth_unfold
  end

  def create_authorization
    @authorization = User::Authorization.create auth_attribures
    AuthorizationBuilder.set_with_omniauth!(@authorization.token, user)
  end

  def self.set_with_omniauth! omniauth_token, user
    authorization = User::Authorization.find_by_token(omniauth_token)
    if authorization && user
      user.authorizations << authorization

      user.email    = authorization.email if user.email.blank?
      user.username = authorization.username if user.username.blank?


      profile_attr = {
          firstname: authorization.first_name || authorization.username,
          lastname: authorization.last_name,
          birthday: authorization.birth_date,
          gender: authorization.gender,
          description: authorization.description,
      }

      profile_attr.each_pair do |k,v|
        user.client[k]= v if user.client[k].blank?
      end
      user.client.remote_avatar_url = authorization.image unless has_avatar?(user)
      user.client.save!

    end
    authorization
  end



  private

  def omniauth_unfold
    auth_attribures[:uid]       = omnihash['uid']
    auth_attribures[:provider]  = omnihash['provider']
    auth_attribures[:data]      = get_extra_data

    get_omniauth_credentials

    auth_attribures[:primary]   = true
    connect_to_user if user.present?
  end

  def omnihash_info
    omnihash['extra']['raw_info'] || omnihash['info']
  end

  def get_extra_data
    data = omnihash['info'].merge(omnihash_info).delete_if do |key, value|
      value.is_a?(Hashie::Mash) or value.is_a?(Array)
    end

    gender = {
        facebook: {
            'male' => true,
            'female' => false
        },
        mailru: {
            '0' => true,
            '1' => false
        },
        vkontakte: {
            '1' => true,
            '2' => false
        }
    }
    data[:gender] = if %w(facebook mailru vkontakte).include? data[:provider]
                      gender[data[:provider]][data[:sex]]
                    end
    data[:birth_day] = data[:bdate] || data['birthday'] || data[:birth_day]
    data[:image] = data[:pic_big] || data[:pic_2] || data[:photo_big] || omnihash_info[:photo_200_orig] || data[:image]
    #data[:image] = data[:pic_big] || data[:pic_2] || data[:photo_big] || omnihash[:extra][:raw_info][:photo_200_orig] || data[:image]
    data[:username] = data[:nickname]
    data
  end

  def get_omniauth_credentials
    if omnihash['credentials'].present?
      auth_attribures[:token]   = omnihash['credentials']['token']
      auth_attribures[:secret]  = omnihash['credentials']['secret']
      auth_attribures[:expires_at] = omnihash['credentials']['expires_at']
    end
  end

  def connect_to_user
    auth_attribures[:primary] = false if user.authorizations.blank?
    auth_attribures[:user_id] = user.id
  end

  def self.has_avatar?(user)
    !!user.client.avatar_url.match(/assets/).blank?
  end
end
