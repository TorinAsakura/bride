# encoding: utf-8
class FirmsController < ApplicationController
  include ControllersExt::FirmPrivate

  respond_to :js, :html, :json

  skip_before_filter :authenticate_user!, only: [:index, :get_firm_catalog_children]

  before_filter :check_owner, only: [:edit, :update, :checkout, :change_text_status,
                                     :destroy, :destroy_banner, :destroy_logo]
  before_filter :set_details, only: [:edit, :update]

  before_filter :define_business_type, only: [:update]
  before_filter :set_public_variables, only: [:customers, :posts, :addresses,
                                              :comments, :show_album, :videos, :show_page, :albums]

  before_filter :find_firm, only: [:addresses, :partners, :update_user_email, :update_slug, :destroy_logo]
  before_filter :set_city, only: :index
  before_filter :authorize_moderator, except: [:index, :show_album, :show_page, :addresses, :posts,
                                               :comments, :search, :get_phone, :videos,
                                               :partners, :customers, :check_slug_present,
                                               :get_firm_catalog_children]

  def index
    index_variables
    @firm_cities = City.city_firms_for_filter

    firm_catalog_id = params[:firm_catalog_id].presence || 'all'

    @firm_catalog = FirmCatalog.find(firm_catalog_id) unless firm_catalog_id.eql?('all')

    firms = Firm.section_firms(@firm_catalog, @city, params[:firms_search])
    t_firms = TFirm.section_firms(@firm_catalog, @city, params[:firms_search])
    @firms = firms + t_firms.uniq_by(&:name)
    @firms = Kaminari.paginate_array(@firms).page(params[:page]).per(Firm.default_per_page)
    @firms = FirmsDecorator.decorate_collection(@firms)

    # @firms = Firm.section_firms({ catalog_id: firm_catalog_id, city: @city, search: params[:firms_search]}).page params[:page]
    # @firms = @firms.decorate
    # TODO change after remove all TFirms

    respond_with(@firms) do |format|
      format.html { index_variables; render layout: !request.xhr? }
      format.js
    end
  end

  def edit
    respond_with(@firm)
  end

  def update
    anchor = params[:anchor]
    respond_to do |format|
      if @business
        if @business.valid?
          @firm.business = @business
          @firm.save
        else
          return render :edit
        end
      end
      @firm.background_image = BackgroundProperty.find(params[:firm].delete(:background_image_id)) if params[:firm][:background_image_id].present?
      if @firm.update_attributes(params[:firm])
        @firm.banner_album.update_for_banner_album(params[:banner_album])
        @firm.update_logo if params[:update_logo]
        format.html { redirect_to edit_firm_path(@firm, anchor: anchor), notice: t('notice.edit_successful') }
        format.json { render json: { logo_url: @firm.logo_url(:usual), image_url: @firm.logo_url } }
        format.js {}
      else
        format.html { render :edit }
        format.json { render json: @firm.errors, status: :unprocessable_entity }
        format.js {}
      end
    end
  end

  def destroy_banner
    @firm.banner_album.photos.find(params[:banner_id]).destroy
  end

  def show_album
    @album = Album.find(params[:album_id])
    @album_photos = @album.photos.page(params[:page])
  end

  def show_page
    @firm_page = FirmPage.find(params[:firm_page_id])
  end

  def comments
    @comments = @firm.comment_threads.includes(:user, :parent, :commentable) unless @firm.blank?
  end

  def addresses
    @city_firm = @firm.city_firms.find_by_city_id(params[:city_id])
  end

  def destroy
    @firm.destroy
    sign_out
    respond_to do |format|
      format.html { redirect_to root_url(subdomain: false), notice: 'Ваша страница успешно удалена' }
      format.json { head :no_content }
    end
  end

  def change_text_status
    respond_with(@firm) do |format|
      format.js { render layout: false }
    end
  end

  def partners
    @partners, __ = @firm.user.grouped_friends
  end

  def customers
    @search = ClientSearch.new()
    @clients = @search.results.includes(:city).displayed.page(params[:page])
  end

  def get_firm_catalog_children
    scope = FirmCatalog.scoped
    if (firm_id = params[:firm_id]).present?
      firm = Firm.find(firm_id)
      if (firm_catalog_ids = firm.all_firm_catalog_ids).present?
        scope = scope.without_firm_catalogs(firm_catalog_ids)
      end
    end
    scope = scope.select('id, name')
    @firm_catalogs = if (parent_id = params[:parent_id]).present?
                       scope.where(parent_id: parent_id)
                     else
                       fc = FirmCatalog.find(params[:id])
                       scope.where("parent_id = ? AND id <> ?", fc.parent_id, fc.id)
                     end
    respond_with(@firm_catalogs) do |format|
      format.json { render @firm_catalogs }
    end
  end

  def destroy_logo
    @firm.remove_logo!
    @firm.save
  end

  def update_user_email
    respond_to do |format|
      @email_changed = true if @firm.update_attributes(params[:firm])
      format.js { render template: 'firms/update_actions/main_settings/update_user_email', layout: false }
    end
  end

  def update_slug
    respond_to do |format|
      @slug_changed = true if @firm.update_attributes(params[:firm])
      format.js { render template: 'firms/update_actions/main_settings/update_firm_slug', layout: false }
      format.html { redirect_to edit_firm_path(@firm) }
    end
  end

  def check_slug_present
    status = Firm.where(slug: params[:firm_slug]).present? || Site.where(name: params[:firm_slug]).present?
    render json: { result: status }
  end

  def get_phone
    @city_firm = CityFirm.find(params[:city_firm_id])
    @phone = @city_firm.base_address.mobile_phone if @city_firm.base_address
  end

  def search
  end

  def update_wedding_city
    city = City.where(wedding_city: true).where(id: params[:city_id]).first
    current_firm.wedding_city = city
    current_firm.save
    redirect_to :back
  end

  private
  def find_firm
    @firm = params[:id].present? ? Firm.find(params[:id]) : Firm.find(request.subdomain)
  end

  def authorize_moderator
    authorize_or_gtfo :moderate, @firm, root_path
  end

  def define_business_type
    if params[:firm][:business_type]
      @business = @firm.business
      case params[:firm][:business_type]
        when 'Pp'
          @business ||= Pp.new(params[:firm][:business])
          @business.passport_date = Time.now
        when 'Ie'
          @business ||= Ie.new(params[:firm][:business])
        when 'Company'
          @business ||= Company.new(params[:firm][:business])
      end

      @business.update_attributes(params[:firm][:business]) unless @business.new_record?

      params[:firm].delete :business
      params[:firm].delete :business_type
    end
  end

  def check_owner
    @firm = params[:id].present? ? Firm.find(params[:id]) : Firm.find(request.subdomain)
    redirect_to action: 'index' and return unless (@firm.user.is? current_user || current_user.has_role?(:admin))
  end

  def set_details
    @card_service = @firm.card_service
    @firm_pages = @firm.firm_pages.ordered.includes(:images, :videos)
    @banner = @firm.banner_album
    @categories = FirmCatalog.roots
    @services = Bonus::Service.list.ordered.decorate
    @purse_payments = PursePaymentDecorator.decorate_collection(@firm.purse.purse_payments.ordered.page(params[:page]))
    @wedding_firm_catalogs = FirmCatalog.ordered.includes(:children).by_firm(@firm)
  end

  def index_variables
    @root = FirmCatalog.roots.includes(children: :children)
    @firms_count  = Firm.count
  end

  def set_city
    if (city = params[:city_id]).present?
      @city = City.find(city) unless city.eql?('all')
    elsif current_user.present?
      @city = current_client.present? ? current_client.wedding_city : current_firm.wedding_city
    end
  end
end
