# encoding: utf-8
class Minisite::ProgrammsController < Minisite::MinisitesController
  skip_before_filter :authenticate_user!, only: :index
  before_filter :access_checks_on_minisite, only: :index

  def index
    @programs = params[:second_day] ? @site.programms.second_day : @site.programms.wedding_day
    render 'programms/index'
  end
end
