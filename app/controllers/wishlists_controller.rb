class WishlistsController < ApplicationController
  skip_before_filter :authenticate_user!, only: :index
  before_filter :define_site, except: :index
  before_filter :find_wishlist, only: [:destroy, :edit, :update]
  respond_to :js, :html

  def edit_wishlist
    @white_list = @site.wishlists.includes(:image).white_list.created_asc
    @black_list = @site.wishlists.black_list.created_asc
  end

  def index
    @site = (params[:site_id]).present? ? Site.find(params[:site_id]) : Site.find_by_name(request.subdomain(Subdomain.position))
    @white_list = WishlistDecorator.decorate_collection(@site.wishlists.includes(:image).white_list.created_asc)
    @black_list = WishlistDecorator.decorate_collection(@site.wishlists.black_list.created_asc)
    @pages = @site.try :pages
    render layout: 'site'
  end

  def create
    @wishlist = Wishlist.new(params[:wishlist])
    @wishlist.site = @site
    @wishlist.client = current_client
    respond_to do |format|
      if @wishlist.save
        format.html { redirect_to :back }
        format.json { render json: @wishlist, status: :created, location: site_edit_wish_list_path(@site) }
      else
        format.html { redirect_to :back }
        format.json { render json: @wishlist.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @wishlist.build_image unless @wishlist.image
  end

  def new
    @wishlist = Wishlist.new
    @wishlist.build_image
    respond_with(@wishlist) do |format|
      format.js { render layout: false }
    end
  end

  def update
    @wishlist.update_attributes(params[:wishlist])
    redirect_to :back
  end

  def update_all
    params[:wishlists].each do |id, param|
      wishlist = @site.wishlists.find(id)
      wishlist.update_attribute(:name, param[:name])
    end
    redirect_to :back
  end

  def destroy
    @wishlist.destroy
    redirect_to :back
  end

  private
  def define_site
    @site = current_client.site
  end

  def find_wishlist
    @wishlist = @site.wishlists.find params[:id]
  end
end
