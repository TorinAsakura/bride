# encoding: utf-8
class Admin::CommunityCategoriesController < AdminController
  layout 'admin_application'
  before_filter :find_community_category, except: [:index]

  def index
    if params[:category_id]
      @community_category = CommunityCategory.find(params[:category_id])
      @communities = @community_category.communities
    end
    @community_categories = CommunityCategory.all
  end

  def show
    @communities = @community_category.communities
  end

  def new
    @community_category = CommunityCategory.new
  end

  def create
    CommunityCategory.create(params[:community_category])
    redirect_to admin_community_categories_path, notice: 'Категория успешно создана'
  end

  def edit
    @moderators = User.with_role(:moderator, @community_category)
    render :new
  end

  def update
    @community_category.update_attributes(params[:community_category])
    redirect_back('Категория успешно обновлена')
  end

  def destroy
    if @community_category.communities.any?
      flash[:notice] = 'Можно удалить только пустую категорию'
    else
      @community_category.destroy
      flash[:notice] = 'Категория успешно удалена'
    end
    redirect_to admin_community_categories_path, notice: 'Категория успешно удалена'
  end

  def remove_avatar
    @community_category.remove_avatar!
    @community_category.save
    render text: 'Аватарка удалена'
  end

  def order_communities
    params[:ids].try(:each_with_index) do |id, index|
      community = @community_category.communities.find(id)
      community.update_attribute(:position, index.to_i + 1)
    end
    render nothing: true
  end

  def order_categories
     params[:ids].try(:each_with_index) do |id, index|
      category = CommunityCategory.find(id)
      category.update_attribute(:position, index.to_i + 1)
    end
    render nothing: true 
  end

  private
  def find_community_category
    @community_category = CommunityCategory.find params[:id] rescue CommunityCategory.new
  end
end

