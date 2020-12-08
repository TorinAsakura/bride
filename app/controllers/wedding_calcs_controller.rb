# encoding: utf-8
class WeddingCalcsController < ApplicationController

  def index
    @site = (params[:site_id]).present? ? Site.find(params[:site_id]) : Site.find_by_name(request.subdomain(Subdomain.position))
    @wedding_calc = @site.wedding_calc
  end

  def edit_calc
    @site = current_client.site
    @wedding_calc = WeddingCalc.where(:site_id => @site.id).first_or_create
  end

  def get_data
    wedding_calc = WeddingCalc.find(params[:wedding_calc_id])

    render :json => {:result => 'ok', :categories => wedding_calc.categories}
  end

  def save_data
    wedding_calc = WeddingCalc.find(params[:wedding_calc_id])

    wedding_calc.categories = params[:categories]

    if wedding_calc.save
      render :json => {:result => 'saved', :params => params}
    else
      render :json => {:result => 'not saved', :params => params}
    end
  end
end
