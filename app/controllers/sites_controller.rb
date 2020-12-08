#encoding: utf-8
class SitesController < ApplicationController

  respond_to :js, :html

  before_filter :find_site_with_pages, except: [:index, :new, :create, :check_name_present]
  before_filter :find_client
  before_filter :search_params, only: :index

  def index
    @search = SiteSearch.new(@search_params)
    @sites = @search.results.displayed.order(sort_params).page(params[:page])
    respond_to do |format|
      format.html { render layout: false if request.xhr? }
      format.js {}
    end
  end

  def show
    @page = @site.pages.where(main: true).first!
    redirect_to site_page_path @site, @page
  end

  def edit
    respond_to do |format|
      format.js { render layout: false}
      format.html {}
    end
  end

  def new
    if @site
      flash[:alert] = 'У Вас уже есть сайт'
      redirect_to site_path current_client.site
    else
      @site = Site.new
    end
  end

  def update
    @site.header_image = BackgroundProperty.find(params[:site].delete(:header_image_id)) if params[:site][:header_image_id].present?
    @site.background_image = BackgroundProperty.find(params[:site].delete(:background_image_id)) if params[:site][:background_image_id].present?
    if @site.update_attributes(params[:site])
      redirect_to edit_site_path(@site.id)
    else
      render :edit
    end
  end

  def create
    @site = Site.new params[:site]
    @site.client = current_client
    respond_with(@site) do |format|
      if @site.save
        format.js
        format.html { redirect_to edit_site_path(@site), notice: 'Сайт создан'}
      else
        format.js
        format.html {render :new}
      end
    end
  end

  def destroy
    @site.destroy if @site
    redirect_to client_path(current_client)
  end

  def update_address
    respond_to do |format|
      if @site.update_attributes(params[:site])
        @site_name_changed = true
        format.js { render 'sites/mini_site_edit/base_settings/update_address', layout: false }
      else
        format.js { render 'sites/mini_site_edit/base_settings/update_address', layout: false }
      end
    end
  end

  def update_base_settings
    respond_to do |format|
      if @site.update_attributes(params[:site])
        @site_changed = true
        format.js { render 'sites/mini_site_edit/base_settings/base_settings', layout: false }
      else
        format.js { render 'sites/mini_site_edit/base_settings/base_settings', layout: false }
      end
    end
  end

  def check_name_present
    if Site.where('sites.name = ?', params[:site_name]).present?
      render json: {result: true}
    else
      render json: {result: false}
    end
  end

  private
  def find_site_with_pages
    @site = Site.find params[:id]
    @pages = @site.try :pages
  end

  def find_client
    @client = current_client
  end

  def sort_params 
    params[:sort]  = params.has_key?(:sort) && params[:sort] == 'popular' ? 'sites.cached_votes_up' : 'current_date - weddings.wedding_date'
    params[:order] = params.has_key?(:order) && params[:order] == 'DESC' ? 'DESC' : 'ASC'
    "#{params[:sort]} #{params[:order]}, sites.id #{params[:order]}"
  end

  def search_params
    params[:search] = Hash.new unless params.has_key? :search 
    params[:search][:city_id] = params[:city_id] if params.has_key? :city_id

    %w(day month year).each { |k| params[:search].delete(k) if params[:search][k].to_i == 0 } if params.has_key? :search
    @search_params = params[:search]
  end
end
