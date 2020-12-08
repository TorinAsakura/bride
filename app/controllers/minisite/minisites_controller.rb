# encoding: utf-8
class Minisite::MinisitesController < Minisite::BaseController
  skip_before_filter :authenticate_user!
  def show
    @page = @site.pages.where(main: true).first!
    redirect_to minisite_page_path @page.name
  end

  def page
    @page = @site.pages.where(name: params[:page], active: true).first
    page_name = @page.try(:name) || 'page_404'
    case page_name
      when 'guestbook'
        @guestbook_notes = @site.guestbooks.includes(:user)
        @guestbook_note = @site.guestbooks.build
      when 'albums'
        @albums = @site.albums.includes([{photos: :album}, :cover])
      else
    end
    render "minisite/minisites/#{page_name}" if @page.blank? || @page.system
  end

  def page_404
    respond_to do |format|
      format.html
    end
  end

  def code
    session_key = "site_code_#{@site.id}"
    site_code = @site.code
    if session[session_key] != site_code
      if (code = params[:site][:code]).present? && code.eql?(site_code)
        session[session_key] = site_code
      end
    end
    redirect_to minisite_page_path('about')
  end
end
