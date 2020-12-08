# encoding: utf-8
class ImagesController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_filter :define_association, except: :show
  respond_to :js, :html

  def create
    @album = @journal.photo_albums.where(system: true).first_or_create(name: 'Фото журнала')
    @photo = @album.photos.new(path: params[:file])
    @photo.save

    render :json => {:filelink => @photo.path.url}
  end

  def index
    @albums = @journal.photo_albums
    @images = []
    @albums.each do |a|
      a.photos.each do |i|
        @images.push(i)
      end
    end
    render :json => json_images(@images)
  end

  def show
    @image = Image.find(params[:id])
    @idea_category = ::Idea::Category.find(params[:idea_category_id])
    respond_to do |format|
      format.html
      format.js { }
    end
  end

  private

  def define_association
    @journal = User.find(params[:user_id]) if params[:user_id]
    @journal = Firm.find(params[:firm_id]) if params[:firm_id]
    redirect_to root_url unless @journal

    @post    = Post.find(params[:post_id])
    redirect_to root_url unless @post
  end

  def json_images(images)
    json_images = []
    images.each do |image|
      json_images << {
        thumb: image.path.url(:thumb),
        image: image.path.url,
        folder: image.photo_album.name
      }
    end
    json_images
  end
end
