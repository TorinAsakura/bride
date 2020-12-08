class InstagramMediaController < ApplicationController
  include SocialServicesHelper
  respond_to :js, :json
  before_filter :set_referrer_for_social_services, :init_instagram_client, except: [:validate_session]

  def index
    @referrer = request.referrer
    @images = []

    instagram_recent_media = InstagramPaginator.paginate(params, @instagram_client)

    instagram_recent_media.each do |media|
      photo_params = {
        "media_id" => media.id,
        "thumb_url" => media.images.thumbnail.url
      }
      @images << Hashie::Mash.new(photo_params)
    end
  end

  def download
    SocialPhotoPerformer.perform!("instagram", @instagram_client, params)
    if params[:upload_to] == "poll"
      performer = SocialPhotoPerformer.performer
      @tmp_poll_images_ids = performer.tmp_poll_images_ids

      respond_to do |format|
        format.js
      end
    else
      album = Album.find(params[:album_id])
      path = polymorphic_path([current_client, album])
      render js: "window.location = '#{path}'"
    end
  end

  def validate_session
    user = User.find(params[:current_user_id])
    account = user.authorizations.where(provider: 'instagram')
    account_data = {}

    if account.blank?
      account_data[:valid] = false
      set_referrer_for_social_services
    else
      account_data[:valid] = true
    end

    respond_with JSON.generate(account_data)
  end

  private
  def init_instagram_client
    account = current_user.authorizations.where(provider: "instagram")
    if account.first
      @instagram_client = Instagram.client(access_token: account.first.token)
    end
  end
end
