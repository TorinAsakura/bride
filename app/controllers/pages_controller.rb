#encoding: utf-8
class PagesController < ApplicationController
  before_filter :find_site

  def index
    @pages = @site.pages
  end

  def new
    @page = Page.new
    @page.site = @site
    respond_to do |format|
      format.js { render layout: false}
      format.html {
        @client = @site.client
        @pages = @site.pages
      }
    end
  end

  def show
    @page = @site.pages.find params[:id]
    @pages = @site.pages

    case @page.name
    when 'guestbook'
          @guestbook_notes = @site.guestbooks.includes(:user)
          @guestbook_new_note = @site.guestbooks.build
    when 'albums'
          @albums = @site.albums.includes([{:photos => :album}, :cover])
    end
  end

  def edit
    @page = Page.find(params[:id])
    respond_to do |format|
      format.js { render layout: false}
      format.html {
        @client = @site.client
        @pages = @site.pages
      }
    end
  end

  def update
    @page = @site.pages.find(params[:id])
    @page.update_attributes(params[:page])
    redirect_to edit_site_path @site
  end

  def create
    @page = Page.new(params[:page])
    @page.site = @site
    @page.save
    redirect_to edit_site_path @site
  end

  def destroy
    @page = @site.pages.find(params[:id])
    @page.destroy unless @page.system
    redirect_to edit_site_path @site
  end

  private
  def find_site
    @site = Site.find params[:site_id]
  end
end
