# encoding: utf-8
class Admin::Idea::IdeasController < AdminController
  layout 'admin_application'

  respond_to :js, :html
  before_filter :update_all, only: :update
  before_filter :find_idea, only: [ :destroy ]
  before_filter :find_idea_category, only: [ :edit, :update ]

  def index
    @idea_categories = ::Idea::Category.includes(:image).all
  end

  def show
    if request.xhr?
      current = ::Idea::Category.find(params[:id]).ideas
      @ideas = ::Idea::Category.find(params[:idea_category_id]).ideas.map do |idea|
        # show only ideas that are not included in current idea_category
        idea unless current.exists?(idea)
      end.compact
      render @ideas
    else
      @idea_category = ::Idea::Category.find(params[:id])
      @ideas = @idea_category.ideas.page(params[:page]).includes(:image)
    end
  end

  def edit; end

  def update; end

  def destroy
    @idea.destroy
    respond_to do |format|
      format.js { render js: 'location.reload();' }
    end
  end

  private
  def update_all
    attrs = %W(common_description common_name common_tag_ids common_color_ids)
    if params[:idea_category] && params[:idea_category][:ideas_attributes] && !attrs.map{|a| params[:idea_category][a]}.compact.empty?
      params[:idea_category][:ideas_attributes].each do |key, h|
        attrs.each do |a|
          # for attrs starting with 'common_' not include this part in key name
          (index = a =~ /_/) ? index += 1 : index = 0
          h[a[index..-1]] = params[:idea_category][a] if params[:idea_category][a]
        end
        params[:idea_category][:ideas_attributes][key] = h
      end
      attrs.each { |a| params[:idea_category].delete(a) }
    end
  end

  def find_idea
    @idea = ::Idea::Idea.find(params[:id])
  end

  def find_idea_category
    @idea_category = ::Idea::Category.find(params[:id])
  end
end
