class Minisite::MyIdeas::CategoriesController < Minisite::BaseController
  skip_before_filter :authenticate_user!
  def show
    @category = Idea::Category.find(params[:id])
    @ideas = @site.ideas.joins(:categories).where(idea_categories: {id: @category.id}).uniq.page(params[:page])
  end

  protected
  def has_menu
    @with_menu = false
  end
end