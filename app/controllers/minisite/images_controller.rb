# encoding: utf-8
class Minisite::ImagesController < Minisite::MinisitesController
  before_filter :access_checks_on_minisite, only: :show

  def show
    @image = Image.find(params[:id])
    @idea_category = ::Idea::Category.find(params[:idea_category_id])
    render layout: false
  end
end
