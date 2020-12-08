# encoding: utf-8
class Minisite::AlbumsController < Minisite::MinisitesController
  skip_before_filter :authenticate_user!, only: :show
  before_filter :get_album, except: [:new, :index, :create]
  before_filter :access_checks_on_minisite, only: :show

  # def index; end -  action in subdomains_controller

  def show
    @photos = @album.photos.includes(:album).page(params[:page])

    respond_to do |format|
      format.html do
        @page =  @site.pages.find_by_name 'albums'
        @pages = @site.pages
      end
      format.js {}
    end
  end

  def new
    @album = @site.albums.new
    respond_to do |format|
      format.html {
        session[:new] = true
      }
      format.js {}
    end
  end

  def edit
    @albums = @site.albums.includes(:cover).order('photo_albums.id ASC')
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def create
    @album = @site.albums.new(params[:album])
    @albums = @site.albums.order('photo_albums.id ASC')
    respond_to do |format|
      if @album.save
        @albums = @site.albums.where('id NOT IN (?)', [@album.id]).order('photo_albums.id ASC') if params[:upload_photos_only]
        format.html { redirect_to minisite_album_path(@album), notice: 'Album was successfully created.' }
        format.js { render :edit if params[:upload_photos_only] }
      else
        format.html { render :new }
      end
    end
  end

  def update
    @albums = @site.albums.order('photo_albums.id ASC')
    respond_to do |format|
      if @album.update_attributes(params[:album])
        format.html do
            @album.destroy if params[:destroy_album]
            redirect_to minisite_all_albums_path
        end
        format.js { render :edit if params[:album].has_key? :pictures }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @album.destroy
    respond_to do |format|
      format.html { redirect_to minisite_all_albums_path }
    end
  end

  def upload_photo
    @album.update_attributes(params[:album])
    @albums = @site.albums
    @photo = @album.photos.first

    respond_to do |format|
      format.js {  }
    end
  end

  private
  def get_album
    @album = Album.find(params[:id])
  end
end
