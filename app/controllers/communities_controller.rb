# encoding: utf-8
class CommunitiesController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:index, :show, :show_post, :show_album, :albums, :rules, :members, :images]
  before_filter :authorize_moderator, only: [:update, :destroy_avatar]
  before_filter :find_community, except: [:index]
  before_filter :rand_clients, only: [:show_post, :show, :members, :rules, :albums, :show_album, :images]
  before_filter :search_params, only: [:members, :show]

  def index
    @community_categories = CommunityCategory.includes(:communities)
  end

  def show
    @search = PostSearch.new(@search_params)
    @posts = @search.results.reorder(posts_sort_params).page(params[:page])
    respond_to do |format|
      format.js
      format.html { render layout: false if request.xhr? }
    end
  end

  def update
    respond_to do |format|
      if @community.update_attributes(params[:community])
        @community.update_avatar if params[:update_avatar]
        format.json { render json: { avatar_url: @community.avatar_url(:thumb), image_url: @community.avatar_url } }
      else
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy_avatar
    @community.remove_avatar!
    @community.save
  end

  def join_the_community
    @community.join_the_community(current_client)
    respond_to do |format|
      format.html { redirect_to :back}
      format.json { head :no_content }
    end
  end

  def leave_the_community
    @community.leave_the_community(current_client)
    respond_to do |format|
      format.html { redirect_to :back}
      format.json { head :no_content }
    end
  end

  def members
    @search = ClientSearch.new(@search_params)
    @clients = @search.results.includes(:user, :city).order(members_sort_params).page(params[:page])
    respond_to do |format|
      format.js
      format.html { render layout: false if request.xhr? }
    end
  end
  
  def albums
    @albums = @community.albums
    @photos = @community.photos.order('created_at DESC').includes(:album).page(params[:page])
  end

  def show_album
    @album = @community.albums.find(params[:album_id])
    @album_photos = @album.photos.page(params[:page]).includes(:album) 
  end

  def rules; end

  def images
    @post_images = @community.images.page(params[:page])
  end

  def show_post
    @post = @community.posts.find(params[:post_id])
    @comments = @post.comment_threads.includes(:user, :commentable).reorder('updated_at DESC').page(params[:page])
    respond_to do |format|
      format.js { render :posts }
      format.html { render layout: false if request.xhr? }
    end
  end

  private
  def find_community
    @community = Community.find(params[:id])
  end

  def authorize_moderator
    authorize_or_gtfo :moderate, @community, root_path
  end

  def rand_clients
    @rand_clients = @community.clients.order('RANDOM()').limit(COMMUNITY_RANDOM_CLIENTS)
  end

  def members_sort_params
    sort  = params.has_key?(:sort) && params[:sort] == 'popular' ? 'clients.cached_votes_up' : 'users.created_at'
    order = params.has_key?(:order) && params[:order] == 'DESC' ? 'DESC' : 'ASC'
    "#{sort} #{order} NULLS LAST"
  end

  def posts_sort_params
    params[:sort]  = params.has_key?(:sort) && params[:sort] == 'last_comment_at' ? 'posts.last_comment_at' : 'posts.created_at'
    params[:order] = params.has_key?(:order) && params[:order] == 'ASC' ? 'ASC' : 'DESC'
    "#{params[:sort]} #{params[:order]} NULLS LAST"
  end

  def search_params
    params[:search] = Hash.new unless params.has_key? :search 
    params[:search][:community_id] = @community.id
    params[:search][:city_id] = params[:city_id] if params.has_key? :city_id

    params[:search].delete(:gender) if params.has_key?(:search) && params[:search].has_key?(:gender) && params[:search][:gender] == 'people'
    %w(day month year).each { |k| params[:search].delete(k) if params[:search][k].to_i == 0 }
    @search_params = params[:search]
  end
end
