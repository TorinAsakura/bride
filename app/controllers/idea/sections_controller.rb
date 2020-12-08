class Idea::SectionsController < Idea::BaseController
  def index
    @sections = @all_sections.page(params[:page])
  end

  def show
    @section = @all_sections.find(params[:id])
    @categories = @section.categories.ordered.page(params[:page])
  end
end
