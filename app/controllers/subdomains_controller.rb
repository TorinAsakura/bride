# encoding: utf-8
class SubdomainsController < ApplicationController
  include ControllersExt::FirmPrivate

  skip_before_filter :authenticate_user!, except: :show_album
  before_filter :find_site_or_firm, only: [:show, :albums, :show_album]
  before_filter :access_checks_on_minisite, only: :albums

  def show
    if @site.present?
      @page = @site.pages.where(main: true).first!
      redirect_to minisite_page_path(@page.name) and return
    elsif @firm.present?
      redirect_to root_url(subdomain: false) and return unless @firm.public_by?(current_user)
      set_public_variables
      @style = @firm.background_image.presence
      @firm = @firm.decorate
      render 'firms/show'
    else
      redirect_to root_url(subdomain: false) and return
    end
  end

  def albums
    if @site.present?
      @pages = @site.pages
      @page  = @site.pages.where(name: 'albums', active: true).first!
      @albums = @site.albums.includes([{photos: :album}, :cover]).ordered.decorate
      @photos = @site.photos.includes(:album).page(params[:page])
      @with_menu = true
      render 'minisite/albums/index', layout: 'clients_site'
    elsif @firm.present?
      set_public_variables
      render 'firms/albums'
    else
      redirect_to root_path(subdomain: '') and return
    end
  end

  def show_album
    @album = Album.find(params[:album_id])
    @album_photos = @album.photos.page(params[:page])
    @firm_pages = @firm.firm_pages.visible
    @banner = @firm.banner_album
    @firm_services = @firm.firm_services
    @videos = @firm.videos
    render 'firms/show_album'
  end

  private
  def find_site_or_firm
    subdomain = request.subdomain(Subdomain.position)
    (@site = Site.find_by_name(subdomain).try(:decorate)).presence || (@firm = Firm.find_by_slug(subdomain)).presence
  end
end
