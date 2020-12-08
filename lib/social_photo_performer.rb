require 'social_photo_performer/base'
require 'social_photo_performer/performer'

module SocialPhotoPerformer
  def self.perform!(type, client, params)
    @base_performer = SocialPhotoPerformer::Base.new(type, client, params)
    if not_blank_photo_ids?(type, params)
      @base_performer.perform!
    end
  end

  def self.performer
    @base_performer.performer
  end

  private
  def self.not_blank_photo_ids?(type, params)
    if type == 'vkontakte'
      return !params[:vk_photos_params][:photo_ids].blank?
    elsif type == 'instagram'
      return !params[:instagram_photo_ids].blank?
    end
  end
end
