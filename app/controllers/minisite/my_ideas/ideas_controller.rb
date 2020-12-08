class Minisite::MyIdeas::IdeasController < Minisite::BaseController
  skip_before_filter :authenticate_user!
  respond_to :js, :html

  def index
    @owner = @site.users.include?(current_user)
    @sections = (@owner ? Idea::Section : @site.idea_sections).joins(:categories).ordered.uniq.decorate
    @categories = (@owner ? Idea::Category : @site.idea_categories).joins(:sections).ordered.uniq.decorate
    @ideas = @site.ideas.page(params[:page])

    respond_with(@ideas) do |format|
      format.html {render layout: !request.xhr?}
    end
  end

  def show
    @category = Idea::Category.find(params[:category_id]) if params[:category_id].present?
    @idea = Idea::Idea.includes(:collection, :image, :colors).find(params[:id])
    @category ||= @idea.categories.first
    @next_idea = @idea.next_idea(@category, @site)
    @prev_idea = @idea.prev_idea(@category, @site)

    @path = minisite_my_ideas_category_idea_path(@category, @idea)

    @user_idea = @site.user.user_ideas.idea(@idea)
    @comments = @idea.comment_threads.includes(:user, :commentable).reorder('updated_at DESC')

    respond_to do |format|
      format.html do
        session[:idea] = @path
        redirect_to minisite_my_ideas_category_path(@category)
      end
      format.js {}
    end
  end

  protected
  def has_menu
    @with_menu = false
  end
end