# encoding: utf-8
class Admin::Idea::SectionsController < AdminController
  layout 'admin_application'
  respond_to :js, :html

  before_filter :find_section, except: [ :index, :new, :create ]

  def index
    @sections = ::Idea::Section.ordered
    respond_to do |format|
      format.html
      format.json { render json: @sections}
    end
  end

  def show
    @categories = @section.categories.ordered

    respond_with(@section) do |format|
      format.html
      format.js { render layout: false }
    end
  end

  def new
    @section = Idea::Section.new

    respond_with(@section) do |format|
      format.js { render layout: false }
    end
  end

  def edit
   respond_with(@section) do |format|
     format.js { render layout: false }
   end
  end

  def create
    @section = ::Idea::Section.new(params[:idea_section])

    respond_to do |format|
      if @section.save
        format.html { redirect_to admin_idea_sections_path}
        format.js { render text: "window.location = '#{admin_idea_sections_path}'" }
      else
        format.html { render :new }
        format.js { render action: :new, layout: false}
      end
    end
  end

  def update
    respond_to do |format|
      if @section.update_attributes(params[:idea_section])
        format.html { redirect_to :back}
        format.js { render text: "window.location = '#{admin_idea_sections_path}'"}
      else
        format.html { render :edit }
        format.js { render action: :edit, layout: false}
      end
    end
  end

  def destroy
    @section.destroy

    respond_to do |format|
      format.html { redirect_to admin_idea_sections_path }
      format.js { head :no_content }
    end
  end

  def new_add_category
    @categories = ::Idea::Category.all

    respond_with(@section) do |format|
      format.js { render layout: false }
    end
  end

  def add_category
    if @section.categories << ::Idea::Category.find(params[:section][:categories])
      respond_to do |format|
        format.js { render text: "window.location = '#{admin_idea_section_path(@section)}'"}
      end
    end
  end

  def remove_category
    @category = ::Idea::Category.find(params[:category_id])
    @section.categories.delete(@category)

    respond_to do |format|
      format.js {}
    end
  end

  def move_left
    @section.increment_position
    @sections = ::Idea::Section.ordered
  end

  def move_right
    @section.decrement_position
    @sections = ::Idea::Section.ordered
  end

  def get_categories
    render json: @section.categories.to_json(only: [:id, :name])
  end
  private
  def find_section
    @section = ::Idea::Section.find(params[:id])
  end
end
