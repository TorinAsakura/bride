# encoding: utf-8
class Admin::Idea::CategoriesController < AdminController
  layout 'admin_application'
  respond_to :js, :html

  before_filter :find_category, except: [ :index, :new, :create ]
  before_filter :find_categories, only: [:move_left, :move_right]
  after_filter :find_categories, only: [:move_left, :move_right]

  def index
    @categories = ::Idea::Category.ordered

    respond_to do |format|
      format.html
      format.json { render json: @categories}
    end
  end

  def show
    @categories = ::Idea::Category.all
    @ideas = @category.ideas.includes(:image).page(params[:page])
  end

  def new
    @category = ::Idea::Category.new
    @section_id = params[:section_id]
    @collections = ::Idea::Collection.all

    respond_with(@category) do |format|
      format.js { render :layout => false}
    end
  end

  def create
    @category = ::Idea::Category.new(params[:idea_category])
    @category.sections << ::Idea::Section.find(params[:section_id])

    respond_to do |format|
      if @idea_category.save
        format.html { redirect_to admin_idea_section_path(params[:section_id]), :notice => "Category was successfully created"}
        format.js { render :text => "window.location = '#{admin_idea_section_path(params[:section_id])}'"}
      else
        format.html { render :new }
        format.js { render :action => :new, :layout => false}
      end
    end
  end

  def edit
    @section = ::Idea::Section.find(params[:section_id])
    @collections = ::Idea::Collection.all

    respond_with(@category) do |format|
      format.js { render layout: false }
    end
  end

  def update
    respond_to do |format|
      if @category.update_attributes(params[:idea_category])
        format.html { redirect_to :back}
        format.js { render :text => "window.location = '#{admin_idea_sections_path}'"}
      else
        format.html { render :edit }
        format.js { render action: :edit, layout: false }
      end
    end
  end

  def destroy
    @category.destroy

    respond_to do |format|
      format.html { redirect_to :back }
    end
  end

  def new_add_ideas
    @sections = ::Idea::Section.all
    render layout: false
  end

  def add_ideas
    params[:ideas].each_key { |idea| @category.ideas << ::Idea::Idea.find(idea) }
    respond_to do |format|
      format.js { render text: "window.location = '#{admin_idea_path(@category)}'"}
    end
  end

  def move_left
    @category.increment_position
  end

  def move_right
    @category.decrement_position
  end

  private
  def find_category
    @category = ::Idea::Category.find(params[:id])
  end

  def find_categories
    if params[:section_id].present?
      @section = ::Idea::Section.find(params[:section_id])
      @categories = @section.categories.ordered
    else
      @categories = ::Idea::Section.ordered
    end
  end
end
