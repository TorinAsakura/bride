# encoding: utf-8
class ClientsController < BaseWeddingController
  respond_to :js, :html, :json

  skip_before_filter :authenticate_user!, only: :index
  before_filter :find_client, except: :index
  before_filter :clients_search_params, only: [:index, :friends]
  before_filter :firms_search_params, only: [:firms]
  before_filter :set_sidebar_variables, only: [:show, :videos, :posts, :friends, :firms, :albums, :show_album]
  before_filter :find_posts, only: [:show, :posts]
  before_filter :authorize_moderator, only: [:edit, :update, :update_user_email, :update_status,
                                             :destroy, :destroy_avatar, :search, :update_wedding_city]

  def index
    @search = ClientSearch.new(@search_params)
    @clients = @search.results.includes(:user, :city).displayed.order(sort_params).page(params[:page])
    respond_to do |format|
      format.html { render layout: false if request.xhr? }
      format.js
    end
  end

  def show
    @comments = @client.comment_threads.includes(:parent, :commentable, :images, :videos, :user).page(params[:page])
    @photos = @user.photos.includes(:album).last(CLIENT_PHOTO_PREVIEWS)

    params.merge!(posts_page: 1)
    respond_to do |format|
      format.js { render :posts }
      format.html { render layout: false if request.xhr? }
      format.json { render json: @client }
    end
  end

  def edit
    @couple  = @client.couple if @client.has_couple?
    @avatar  = @client.user.avatar
    @wedding = @client.wedding || Wedding.new
    @timetables = @wedding.timetables.sort_by(&:index_number).reverse.group_by(&:t_type)
    @site    = @client.site
    @pages   = @site.try :pages
  end

  def update
    params[:client].delete_if{ |k, v| v.nil? }

    respond_to do |format|
      if @client.update_attributes(params[:client])
        @client.update_avatar if params[:update_avatar]
        format.json { render json: { avatar_url: @client.avatar_url(:usual), image_url: @client.avatar_url } }
        format.html { redirect_to edit_client_path(@client), notice: t('notice.edit_successful') }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
        format.html { render :edit }
      end
    end
  end

  def update_user_email
    respond_to do |format|
      @client.update_attributes(params[:client])
      format.js { render template: 'clients/update_actions/main_settings/update_user_email', layout: false }
    end
  end

  def update_status
    respond_to do |format|
      @client.update_attributes(params[:client])
      format.js { render 'clients/update_actions/update_status' }
    end
  end

  def destroy
    @client.destroy
    sign_out
    respond_to do |format|
      format.html { redirect_to root_url(subdomain: false), notice: 'Ваша страница успешно удалена' }
      format.json { head :no_content }
    end
  end

  def search_couple
    id = params[:search_params][:couple_id].split('/').last
    @client = id.present? ? ClientSearch.new(id: id).results.last : nil
  end

  def show_album
    @album = @user.albums.find(params[:album_id])
    @album_photos = @album.photos.page(params[:page]).includes(:album)
  end

  def destroy_avatar
    @client.remove_avatar!
    @client.avatar = nil
    @client.save
  end

  def update_wedding_city
    city = City.where(wedding_city: true).where(id: params[:city_id]).first
    @client.wedding_city = city
    @client.save
    respond_with @client
    #redirect_to :back
  end

  def albums
    @albums = @client.albums.includes(:cover)
    @photos = @user.photos.order('created_at DESC').includes(:album).page(params[:page])
  end

  def friends
    case params[:section]
    when 'online'  then @search_params.merge!(friendship_status: 'accepted', only_online: true)
    when 'pending' then @search_params.merge!(friendship_status: 'pending')
    else @search_params.merge!(friendship_status: 'accepted')
    end
    @search = ClientSearch.new(@search_params.except(:sort, :order).merge(owner_id: @user.id))
    @friends = @search.results.includes(:city).displayed.order(sort_params).page(params[:page])
    respond_to do |format|
      format.html { render layout: false if request.xhr? }
      format.js
    end
  end

  def firms
    @search = FirmSearch.new(@search_params.merge(owner_id: @user.id).except(:without_avatar))
    @firms = FirmsDecorator.decorate_collection @search.results.catalog_ordered.page(params[:page])
    respond_to do |format|
      format.html { render layout: false if request.xhr? }
      format.js
    end
  end

  def videos
    videos = case params[:search_type]
               when 'my'      then MediaContent.user_created(@user.id)
               when 'starred' then MediaContent.user_favorites(@user.id)
               else MediaContent.user_owns(@user.id)
             end
    @videos = params[:videos_search] ? videos.search(params[:videos_search]).page(params[:page]) : videos.page(params[:page])
  end

  def avatar
    @avatar = @client.avatar
    if @avatar_image = @client.avatar_image
      @avatar_comments = @client.avatar_image.comment_threads.includes(:parent, :commentable, :images, :videos, :user)
    end
  end

  def posts
    respond_to do |format|
      format.js
      format.html { render layout: false if request.xhr? }
    end 
  end

  private
  def find_client
    @client = Client.includes(:user).find(params[:id])
    @user = @client.user
  end

  def authorize_moderator
    @client = Client.find(params[:id])
    authorize! :moderate, @client
  end

  def sort_params 
    params[:sort]  = params.has_key?(:sort) && params[:sort] == 'popular' ? 'clients.cached_votes_up' : 'users.created_at'
    params[:order] = params.has_key?(:order) && params[:order] == 'ASC' ? 'ASC' : 'DESC'
    "#{params[:sort]} #{params[:order]}, users.id #{params[:order]}"
  end

  def clients_search_params
    params[:search] = Hash.new unless params.has_key? :search 
    params[:search][:city_id] = params[:city_id] if params.has_key? :city_id
    params[:search][:without_avatar] = false unless params[:search].has_key? :without_avatar

    params[:search].delete(:gender) if params.has_key?(:search) && params[:search].has_key?(:gender) && params[:search][:gender] == 'people'
    %w(day month year).each { |k| params[:search].delete(k) if params[:search][k].to_i == 0 }
    @search_params = params[:search]
  end

  def firms_search_params
    params[:search] = Hash.new unless params.has_key? :search 
    @search_params = params[:search]
  end

  def set_sidebar_variables
    @avatar = @client.avatar
    @albums_sidebar  = @client.albums.reorder(:updated_at).last(CLIENT_SIDEBAR_ALBUMS)
    @friends_sidebar = @client.friends.any? ? @client.friends.only_clients.order('RANDOM()').first(CLIENT_SIDEBAR_FRIENDS) : []
    @videos_sidebar  = @client.videos.first(CLIENT_SIDEBAR_VIDEOS)
  end

  def find_posts
    params[:search] = Hash.new unless params.has_key? :search 
    params[:search].merge!(journal_id: @user.id)
    params[:search].merge!(show_type: 'all') unless params[:search].has_key? :show_type

    @search = PostSearch.new(params[:search])
    @posts = @search.results.page(params[:posts_page]).per(CLIENT_POSTS_PREVIEWS)
  end
end


