#encoding: utf-8

class Admin::StaticPagesController < AdminController
  def index
    @pages = StaticPage.where(true)
  end

  def show
    @page = StaticPage.find params[:id]
  end

  def new
    @page = StaticPage.new
  end

  def create
    @page = StaticPage.new params[:static_page]
    if @page.save
      redirect_to admin_static_page_path(@page)
    else
      render :new
    end
  end

  def edit
    @page = StaticPage.find params[:id]
  end

  def update
    @page = StaticPage.find params[:id]
    if @page.update_attributes params[:static_page]
      redirect_to admin_static_page_path(@page)
    else
      render :edit
    end
  end

  def destroy
    @page = StaticPage.find params[:id]
    @page.destroy

    redirect_to admin_static_pages_url
  end
end
