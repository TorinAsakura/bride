# encoding: utf-8
class Admin::CommunitiesController < AdminController
  layout 'admin_application'
  before_filter :find_community, except: [:index, :new, :create]

  def new
    community_category = CommunityCategory.find(params[:id])
    @community = community_category.communities.new
  end

  def edit
    @moderators = User.with_role(:moderator, @community)
    @post_categories = @community.post_categories
    render :new
  end

  def create
    @community = Community.create(params[:community])
    redirect_to admin_community_categories_path(category_id: @community.community_category), notice: 'Клуб успешно создан'
  end

  def update
    @community.update_attributes(params[:community])
    redirect_back('Клуб успешно обновлён')
  end

  def destroy
    @community.destroy
    redirect_to admin_community_categories_path(category_id: @community.community_category), notice: 'Клуб успешно удалён'
  end

  def remove_moderator
    @user = User.find(params[:user_id])
    @user.custom_remove_role :moderator, @community
    @moderators = User.with_role(:moderator, @community)
    render 'add_moderator'
  end

  def add_moderator
    user = User.find_by_email(params[:email])
    user.add_role(:moderator, @community) if user.present?
    @moderators = User.with_role(:moderator, @community)
  end

  def remove_post_category
    post_category = @community.post_categories.find(params[:post_category_id])
    post_category.destroy
    @post_categories = @community.post_categories
    render 'add_post_category'
  end

  def add_post_category
    post_category = @community.post_categories.new(name: params[:name])
    @post_categories = @community.post_categories
    render text: 'error' unless post_category.save 
  end

  def remove_logo
    if @community.present?
      @community.remove_logo!
      @community.save
      render text: 'Логотип удален'
    else
      render text: 'Сообщество не найдено', status: 403
    end
  end

  def update_post_category
    post_category = @community.post_categories.find(params[:post_category_id])
    post_category.update_attributes params[:community_post_category]
    respond_to do |format|
      format.json { respond_with_bip(post_category)}
    end
  end

  private 
  def find_community
    @community = Community.find params[:id]
  end
end
