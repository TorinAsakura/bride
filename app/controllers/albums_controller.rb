# encoding: utf-8
class AlbumsController < ApplicationController
  before_filter :find_resource
  before_filter :find_album, except: [ :new, :index, :create ]
  before_filter :authorize_moderator, except: [ :index, :show ]

  def index
    @albums = @resource.albums.includes(:cover).includes(photos: :album)

    respond_to do |format|
      format.html do
        if params[:site_id].present?
          @site = Site.find params[:site_id]
          @page =  @site.pages.find_by_name 'albums'
          @pages = @site.pages
          render 'pages/show'
        end
      end
      format.json { render json: @albums }
    end
  end

  def show
    @photos = @album.photos.includes(:album)

    respond_to do |format|
      format.html do
        if params[:site_id].present?
          @site = Site.find params[:site_id]
          @page =  @site.pages.find_by_name 'albums'
          @pages = @site.pages
          render 'pages/system/album'
        end
      end
      format.json { render json: @album }
      format.js
    end
  end

  def new
    @albums = @resource.albums
    @album = @resource.albums.new

    respond_to do |format|
      format.html do
        session[:new] = true
        redirect_to polymorphic_path([@resource, :albums])
      end
      format.json { render json: @album }
      format.js
    end
  end

  def edit
    @albums = @resource.albums.includes(:cover)

    respond_to do |format|
      format.html
      format.json { render json: @album }
      format.js
    end
  end

  def create
    @album = @resource.albums.new(params[:album])
    @albums = @resource.albums

    respond_to do |format|
      if @album.save
        format.html { redirect_to polymorphic_path([@resource, @album]), notice: 'Album was successfully created.' }
        format.js
      else
        format.html { render :new }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @albums = @resource.albums

    respond_to do |format|
      if @album.update_attributes(params[:album])
        format.html { redirect_to :back }
        format.js { render :edit if params[:album].has_key? :pictures }
        format.json do
          @banner_album = @album.firm.banner_album
          @banner_album.cover = @album.photos.last
          @banner_album.save
          render json: { path: @banner_album.cover.banner_path.usual.url }
        end
      else
        format.html { render :edit }
        format.json { render json: @album.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @album.destroy

    respond_to do |format|
      format.html { redirect_to polymorphic_path([@resource, :albums]) }
      format.json { head :no_content }
    end
  end

  def upload_photo
    @album.update_attributes(params[:album])
    @albums = @resource.albums
    @photo = @album.photos.first

    respond_to do |format|
      format.js
    end
  end

  private
  def find_resource
    @resource = if params[:user_id]
                  User.find(params[:user_id])
                elsif params[:client_id]
                  Client.find(params[:client_id])
                elsif params[:site_id]
                  Site.find(params[:site_id])
                elsif params[:community_id]
                  Community.find(params[:community_id])
                elsif request.subdomain.present?
                  Firm.find(request.subdomain)
                end
    redirect_to root_url unless @resource
  end

  def find_album
    @album = Album.find(params[:id])
  end

  def index_path
    if params[:site_id].present?
      site_page_path @resource, @resource.pages.find_by_name('albums')
    else
      polymorphic_path([@resource, :albums])
    end
  end

  def authorize_moderator
    authorize_or_gtfo :moderate, @resource, polymorphic_path(@resource)
  end
end
