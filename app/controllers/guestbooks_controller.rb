# encoding: utf-8
class GuestbooksController < ApplicationController
  before_filter :find_site

  def index
    @guestbooks = @site.guestbooks.includes(:user)
  end

  def create
    @entry = @site.guestbooks.new(params[:guestbook])
    @entry.user = current_user
    @entry.save

    respond_to do |format|
      format.html {redirect_to minisite_page_path 'guestbook'}
      format.js {
        @guestbook_new_note = @site.guestbooks.build
        render layout: false
      }
    end
  end

  def destroy
    @guestbook = @site.guestbooks.find(params[:id])
    @guestbook.destroy
    redirect_to site_guestbooks_path(@site.id)
  end

  private

  def find_site
    @site = Site.find_by_name(request.subdomain(Subdomain.position)) || Site.find(params[:site_id])
  end

end
