# encoding: utf-8
class PhotosController < ApplicationController
  before_filter :find_resource
  before_filter :authorize_moderator, except: [ :index, :show ]
  skip_before_filter :authenticate_user!, only: :show

  def index
    @user = User.find(params[:user_id]) if params[:user_id]
    @user = Firm.find(params[:firm_id]) if params[:firm_id]

    @albums = @user.albums
    respond_to do |format|
      format.html
      format.json { render json: @user_photos }
    end
  end

  def show
    @album = @resource.albums.find(params[:album_id])
    @photo = @album.photos.includes(:album).find(params[:id])
    @next = @photo.next_photo
    @prev = @photo.prev_photo
    @index = @album.photo_ids.find_index(@photo.id)

    @comments = @photo.comment_threads.includes(:user, :commentable).reorder('updated_at DESC')

    @next_path  = photo_link(@resource, @album, @next) unless @next.nil?
    @prev_path  = photo_link(@resource, @album, @prev) unless @prev.nil?
    @photo_path = photo_link(@resource, @album, @photo) unless @photo.nil?
    @photo_edit_path = edit_polymorphic_path([@resource, @album, @photo]) unless @photo.nil?

    respond_to do |format|
      format.html do
        session[:photo] = @photo_path
        redirect_to album_link @resource, @album   
      end
      format.js { }
    end
  end

  def new
    @photo = Photo.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_photo }
    end
  end

  def edit
    @album = @resource.albums.find(params[:album_id])
    @photo = @album.photos.includes(:album).find(params[:id])
  end

  def create
    @photo = @resource.albums.find(params[:album_id]).photos.new(params[:photo])
    respond_to do |format|
      if @photo.save
        format.html { redirect_to @photo, notice: 'Фотография успешно создана' }
        format.json { render json: @photo, status: :created, location: @photo }
        format.js { render :layout => false  }
      else
        format.html { render :new }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
        format.js { render :json => @path  }
      end
    end
  end

  def update
    @photo = @resource.albums.find(params[:album_id]).photos.find(params[:id])

    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        format.html { redirect_to :back }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @photo = @resource.albums.find(params[:album_id]).photos.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html do
        if current_firm
          redirect_to album_path(@photo.photo_album_id)
        elsif current_client
          redirect_to client_album_path(current_client, @photo.photo_album_id)
        end
      end
      format.json { head :no_content }
      format.js {}
    end
  end

  def make_avatar
    @photo = @resource.albums.find(params[:album_id]).photos.find(params[:id])
    current_user.avatar = @photo.path

    respond_to do |format|
      if current_user.save
        format.json{ head :no_content,  :status => :ok}
      else
        format.json{ render json: @photo.errors, status: :unprocessable_entity  }
      end
    end
  end

  def make_cover
    @album = @resource.albums.find(params[:album_id])
    @photo = @album.photos.find(params[:id])
    @album.cover = @photo

    respond_to do |format|
      if @album.save
        format.json{ head :no_content, :status => :ok}
      else
        format.json{ render json: @album.errors, status: :unprocessable_entity  }
      end
    end
  end

  private
  def find_resource
    @resource = if params[:user_id]
                  User.find(params[:user_id])
                elsif params[:client_id]
                  Client.find(params[:client_id])
                elsif params[:community_id]
                  Community.find(params[:community_id])
                elsif params[:site_id]
                  Site.find(params[:site_id])
                elsif request.subdomain.present?
                  Firm.where(slug: request.subdomain).last || Site.where(name: request.subdomain).last
                end
    redirect_to root_url unless @resource
  end

  def authorize_moderator
    authorize_or_gtfo :moderate, @resource, polymorphic_path(@resource)
  end

  def photo_link resource, album, photo
    if album.is_resource? 'Community', 'Client' then polymorphic_path([resource, album, photo])
    elsif album.is_resource? 'Firm', 'Site' then album_photo_path(album, photo)
    end
  end

  def album_link resource, album
    if album.is_resource? 'Site' then minisite_album_path(album)
    elsif album.is_resource? 'Firm' then album_path(album)
    elsif album.is_resource? 'Community', 'Client' then polymorphic_path([resource, album])
    end
  end
end
