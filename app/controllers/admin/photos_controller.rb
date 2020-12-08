# encoding: utf-8
class Admin::PhotosController < AdminController
  layout 'admin_application'

  def index
    @photos = AdminPhoto.where(true).includes(:tags).page(params[:page])
  end

  def show
    @photo = AdminPhoto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @photo }
    end
  end

  def new
    @photo = AdminPhoto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @photo }
    end
  end

  def edit
    @photo = AdminPhoto.find(params[:id])
  end

  def create
    @photo = AdminPhoto.new(params[:admin_photo])

    respond_to do |format|
      if @photo.save
        format.html { redirect_to  @photo, notice: 'Photo album was successfully created.' }
        format.json { render json: @photo, status: :created, location: @photo }
      else
        format.html { render :new }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @photo = AdminPhoto.find(params[:id])

    respond_to do |format|
      if @photo.update_attributes(params[:admin_photo])
        format.html { redirect_to  @photo, notice: 'Photo album was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: @photo.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @photo = AdminPhoto.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to admin_photos_url }
      format.json { head :no_content }
    end
  end
end
