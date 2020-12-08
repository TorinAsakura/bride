# encoding: utf-8
class Minisite::MyideasController < Minisite::MinisitesController
  skip_before_filter :authenticate_user!, only: [:index, :show, :idea_categories, :search]
  before_filter :access_checks_on_minisite, only: [:index, :show, :idea_categories, :search]

  # all idea_sections
  def index
    @sections = ::Idea::Section.all
  end

  # all idea_categories of current section
  def idea_categories
    @idea_section = ::Idea::Section.find(params[:id])
    @idea_categories = @idea_section.categories
    @user_map = {}
    @idea_categories.each do |ic|
      ui = ::Idea::UserIdea.includes(:idea => :image).where(:user_id => current_user.id,
                                                    :category_id => ic.id,
                                                    :cover => true).first
      @user_map[ic.id] = ui.idea.image.image_url if (ui && ui.idea.image)
    end
  end

  # all user_ideas of current idea_category
  def show
    @idea_section = ::Idea::Section.find(params[:id])
    @idea_category = ::Idea::Category.find(params[:idea_category_id])
    @ideas = @idea_category.user_ideas.includes(:idea).where(:user_id => current_user.id)
  end

  def search
    @q = params[:q]
    @ideas = ThinkingSphinx.search @q, :classes => [Idea], :match_mode => :any,
      :index => "idea_base_core, idea_colors_core, idea_base_delta, idea_colors_delta"
  end

  def cover
    @user_idea = ::Idea::UserIdea.find(params[:id])
    @user_idea.trigger_cover
  end

  def create
    @user_idea = ::Idea::UserIdea.create(:user_id => current_user.id,
                                 :idea_id => params[:id],
                                 :category_id => params[:idea_category_id])

    @idea = ::Idea::Idea.find(params[:id])
    @idea_category = ::Idea::Category.find(params[:idea_category_id])
  end

  def update
    @idea_category = ::Idea::Category.find(params[:id])
    if @idea_category.update_attributes(params[:idea_category])
      if params[:idea_category].has_key?(:pictures)
        @idea_category.new_photos.each do |idea|
          ::Idea::UserIdea.create(user_id: current_user.id, idea_id: idea.id, category_id: @idea_category.id)
        end
      end
      render text: "window.location = '#{minisite_myidea_ideas_path(params[:idea_section_id], @idea_category.id)}'"
    end
  end

  def destroy
    @user_idea = ::Idea::UserIdea.where(:category_id => params[:idea_category_id],
                                :idea_id => params[:id],
                                :user_id => current_user.id).first
    @user_idea.destroy if @user_idea

    @idea = ::Idea::Idea.find(params[:id])
    @idea_category = ::Idea::Category.find(params[:idea_category_id])
  end

  def show_idea
    @idea_section = ::Idea::Section.find(params[:idea_section_id])
    @idea_category = ::Idea::Category.find(params[:idea_category_id])
    @idea = ::Idea::Idea.find(params[:id])
  end
end
