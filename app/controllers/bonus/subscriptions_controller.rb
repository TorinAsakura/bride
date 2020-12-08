class Bonus::SubscriptionsController < ApplicationController
  respond_to :js, :html
  before_filter :set_form_and_service

  def new
    @subscription = @firm.bonus_subscriptions.build(service: @service, signing_service: @signing_service)
    if @service.uniq_form?
      @subscription.signing_object_type = @service.signing_object_name
      set_signing_objects unless request.xhr?
    else
      @subscription.amount = @service.price(@firm)
    end
    @subscription.package = @service.packages.first if @service.pro? && @signing_service.persisted? && @signing_service.active?
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @has_pro = @firm.has_active_pro?
    @subscription = @firm.bonus_subscriptions.build(service: @service, payer: current_user)
    if (cf = current_firm).present? && @firm.eql?(cf) || (dealer = @firm.dealer).blank? || dealer.eql?(cf)
      if @signing_service.new_record? && @service.trial?
        @signing_service.send(:add_trial!)
      else
        if @service.uniq_form?
          @subscription.signing_object_id = params[:bonus_subscription][:signing_object_id]
          @subscription.signing_object_type = @service.signing_object_name
          @subscription.amount = @service.price(@firm, @subscription.signing_object)
        else
          @subscription.amount = @service.price(@firm)
          if params[:bonus_subscription].present? && (package_id = params[:bonus_subscription][:package_id]).present? # Pro Service package select
            @subscription.package_id = package_id
            @subscription.amount = @subscription.amount*@subscription.package.amount_coefficient
          end
        end
        if (deleted_signing_object = @subscription.deleted_signing_object).present? && @subscription.signing_base_objects.with_deleted.many? && deleted_signing_object.payed?
          deleted_signing_object.send(:paranoid_recover!)
        elsif @service.uniq_form? && @subscription.all_signing_objects.empty?
          @subscription.send(:push_signing_object!)
        else
          @subscription.save
        end
      end
    end
    @firm.reload
    set_signing_objects if params[:item_block].present?
    @services = Bonus::Service.list.ordered.decorate unless @has_pro
    respond_to do |format|
      format.js
    end
  end

  protected
  def set_form_and_service
    @firm = (firm_id = request.subdomain).present? ? Firm.find(firm_id) : current_firm
    @service = Bonus::Service.find(params[:service_id])
    @signing_service = @firm.bonus_signing_services.service(@service).first_or_initialize
  end

  def set_signing_objects
    so_name = @service.signing_object_name
    @items = "#{so_name}Decorator".constantize.decorate_collection(so_name.constantize.ordered.by_firm(@firm))
  end
end