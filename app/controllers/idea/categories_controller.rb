class Idea::CategoriesController < Idea::BaseController
  def show
    @section = @all_sections.find(params[:section_id])
    @category = Idea::Category.includes(:ideas).find(params[:id])
    @ideas = @category.ideas.ordered.includes(:image, :colors).uniq.page(params[:page])
    respond_with(@ideas) do |format|
      format.html {render layout: !request.xhr?}
    end
  end
end
