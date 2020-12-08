# encoding: utf-8
class Minisite::GuestsController < Minisite::BaseController
  respond_to :html, :js
  skip_before_filter :authenticate_user!, only: :index
  before_filter :access_to_moderate_site, except: :index
  before_filter :set_guest, except: [:index, :new, :create, :sort]
  before_filter :set_guests, only: :index

  def index
    respond_with(@guests) do |format|
      format.html
      format.xls
    end
  end

  def show
    respond_with(@guest) do |format|
      format.html do
        redirect_to action: :index
      end
      format.js
    end
  end

  def new
    @guest = case params[:group]
               when 'groom'
                 @site.guests.groom.new
               else
                 @site.guests.bride.new
             end
    respond_with(@guest) do |format|
      format.html do
        set_guests
        render action: :index
      end
      format.js
    end
  end

  def create
    @guest = @site.guests.create(params[:guest])
    respond_with(@guest)
  end

  def edit
    respond_with(@guest) do |format|
      format.html do
        set_guests
        render action: :index
      end
      format.js
    end
  end

  def update
    @guest.update_attributes(params[:guest])
    respond_with(@guest)
  end

  def destroy
    @guest.destroy
    respond_with(@guest)
  end

  def confirm
    @guest.confirm!(params[:status])
    respond_with(@guest)
  end

  def sort
    @guests = @site.guests
    @guests = case params[:group]
                when 'groom'
                  @guests.groom
                else
                  @guests.bride
              end
    params[:ids].each_with_index do |id, index|
      @guests.find(id).update_attribute(:position, index.to_i+1)
    end
    render nothing: true
  end

  protected
  def set_guest
    @guest = @site.guests.find(params[:id])
  end

  def set_guests
    @guests = {
        groom: @site.guests.groom,
        bride: @site.guests.bride
    }
  end
end
