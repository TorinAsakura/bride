# encoding: utf-8
class Seating::BaseController < ApplicationController
  respond_to :html, :json
  before_filter :set_site_and_access

  protected
  def set_site_and_access
    @site = (params[:site_id]).present? ? Site.find(params[:site_id]) : Site.find_by_name(request.subdomain(Subdomain.position))
    authorize! :moderate, @site
    @guests = @site.guests
    @plan = @site.seating_plan || @site.seating_plans.create
  end
end
