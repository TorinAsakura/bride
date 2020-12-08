# encoding: utf-8
class Idea::IdeasController < Idea::BaseController
  respond_to :js, :html
  skip_before_filter :authenticate_user!, only: [:show, :index]
  before_filter :find_idea, only: [:show, :add, :remove, :edit, :update, :destroy]
  before_filter :set_parents, only: [:index, :show, :add, :remove]
  before_filter :set_instance_variables, only: :index
  before_filter :authorize_admin, only: [:edit, :update, :destroy]

  def index
    @ideas = Idea::Idea.includes(:image).joins(:collection)
    search_params = false

    if @category.present?
      search_params = true
      @ideas = @category.collection.ideas
    end

    if params[:ideas_search].present?
      search_params = true
      @color_names = params[:ideas_search].split(',')
      @colors = Tag.where(name: @color_names).map(&:id)
      @ideas = @ideas.search(params[:ideas_search]) unless @colors.present?
    end

    if params[:tags].present?
      search_params = true
      @ideas = @ideas.tagged_with(params[:tags].split(','))
    end

    if params[:colors].present? || @colors.present?
      search_params = true
      @colors = params[:colors].split(',').map(&:to_i) unless @colors.present?
      @color_names = Tag.where(id: @colors).map(&:name).join(',') unless @color_names.present?
      @ideas = @ideas.joins(:taggings).where('taggings.tag_id in (?)', @colors)
    elsif (color = params[:color]).present?
      search_params = true
      hex_color = Tag::COLORS.map{|k,v| k if v.eql?(color)}.compact.first
      @color = Tag.color.where(color: hex_color).first
      @ideas = @ideas.joins(:taggings).where(taggings: {tag_id: @color.id}) if @color.present?
    end
    @ideas = (search_params ? @ideas.ordered.uniq : @ideas.order('random()')).page(params[:page])

    respond_with(@ideas) do |format|
      format.html {render layout: !request.xhr?}
    end
  end

  def show
    @next_idea = @idea.next_idea(@category)
    @prev_idea = @idea.prev_idea(@category)
    @category ||= @idea.collection.categories.first
    @section ||= @category.sections.first

    @path = @section && @category ? idea_section_category_idea_path(@section, @category, @idea) : idea_idea_path(@idea)

    @user_idea = current_user.user_ideas.idea(@idea) if current_user.present?
    @comments = @idea.comment_threads.includes(:user, :commentable).reorder('updated_at DESC')

    respond_to do |format|
      format.html do
        if params.has_key?(:section_id) && params.has_key?(:category_id)
          session[:idea] = @path
          redirect_to idea_section_category_path(@section, @category)
        else
          session[:idea] = idea_idea_path(@idea)
          redirect_to idea_ideas_path
        end
      end
      format.js {}
    end
  end

  def add
    @user_idea = current_user.user_ideas.idea(@idea).category(@category).create
  end

  def remove
    @user_idea = current_user.user_ideas.idea(@idea).category(@category)
    @user_idea.destroy_all if @user_idea
  end

  def edit; end

  def update
    @idea.update_attributes(params[:idea])
    redirect_to :back
  end

  def destroy
    @idea.destroy
    redirect_to idea_ideas_path
  end

  private
  def set_parents
    @section = Idea::Section.find(params[:section_id]) if params[:section_id].present?
    @category = Idea::Category.find(params[:category_id]) if params[:category_id].present?
  end

  def find_idea
    @idea = Idea::Idea.includes(:collection, :image, :colors).find(params[:id])
  end

  def authorize_admin
    authorize_or_gtfo :admin, @idea, root_url
  end
end
