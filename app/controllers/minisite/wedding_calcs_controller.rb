# encoding: utf-8

class Minisite::WeddingCalcsController < Minisite::MinisitesController
  skip_before_filter :authenticate_user!
  before_filter :access_checks_on_minisite

  def index
    @wedding_calc = @site.wedding_calc
    render 'wedding_calcs/index'
  end

  def get_data
    wedding_calc = WeddingCalc.find(params[:wedding_calc_id])
    render json: { result: 'ok', categories: wedding_calc.categories }
  end
end
