class VkontakteMediaController < ApplicationController
  include SocialServicesHelper
  respond_to :js, :json
  before_filter :set_referrer_for_social_services, :init_vk_client, except: [:validate_session]

  def index
    @referrer = request.referrer
    remote_albums = @vk_client.photos.get_albums
    @albums = []

    remote_albums.each do |album|
      album_hash = Hashie::Mash.new(album)
      album_hash.thumb_url = @vk_client.photos.getById(photos: ["#{album_hash.owner_id}_#{album_hash.thumb_id}"]).first.src
      @albums << album_hash
    end
  end

  def show
    @aid = params[:id].to_i
    @album_name = @vk_client.photos.get_albums(aids: [@aid]).first.title
    @photos = VkontaktePaginator.paginate(params, @vk_client)
  end

  def download
    SocialPhotoPerformer.perform!("vkontakte", @vk_client, params)
    if params[:upload_to] == 'poll'
      performer = SocialPhotoPerformer.performer
      @tmp_poll_images_ids = performer.tmp_poll_images_ids

      #NOTE use respond_with
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
    account = user.authorizations.where(provider: 'vkontakte')
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
  def init_vk_client
    account = current_user.authorizations.where(provider: "vkontakte")
    if account.first
      @vk_client = VkontakteApi::Client.new(account.first.token)
    else
      raise "Not allowed token"
    end
  end
end
