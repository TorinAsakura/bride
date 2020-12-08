# encoding: utf-8
class StaticPagesController < ApplicationController
  skip_filter :authenticate_user!
  respond_to :html

  def show
    @page = StaticPage.active.find_by_link params[:page_url]

    respond_with(@page) do |format|
      format.html{render 'page_404' if @page.blank?}
    end
  end
end
