# encoding: utf-8
class PostsController < ApplicationController
  respond_to :js, :html

  skip_before_filter :authenticate_user!, only: [:show]
  before_filter :find_journal
  before_filter :find_post, only: [ :edit, :update, :show, :destroy, :accept, :refuse ]
  before_filter :authorize_moderator, only: [ :new, :create, :edit, :update, :destroy ]

  def index
    @posts = @journal.posts
  end

  def new
    @post_form = PostForm.new(@journal.posts.new, current_user)

    respond_to do |format|
      format.html do
        session[:new] = true
        redirect_to journal_page
      end
      format.js {}
    end
  end

  def edit
    @post_form = PostForm.new(@post, current_user)
    respond_to do |format|
      format.js {}
    end
  end

  def update
    @post_form = PostForm.new(@post, @post.user)

    respond_to do |format|
      if @post_form.submit(params[:post])
        format.json { render json: { images_url: post_images_path(@post_form.post), post_url: post_page(@post_form.post)}}
      else
        format.json { render json: @post_form.post, status: :unprocessable_entity }
      end
    end
  end

  def show
    @post.increment! :views
    @comments = @post.comment_threads.includes(:user, :commentable).reorder('updated_at DESC')

    respond_to do |format|
      format.html do
        session[:post] = post_page(@post)
        redirect_to journal_page
      end
      format.js {}
    end
  end

  def destroy
    @post.destroy
    redirect_to journal_page
  end

  def create
    @post_form = PostForm.new(@journal.posts.new, current_user)
    respond_to do |format|
      if @post_form.submit(params[:post])
        format.json { render json: { images_url: post_images_path(@post_form.post), post_url: post_page(@post_form.post)}}
      else
        format.json { render json: @post_form.errors, status: :unprocessable_entity }
      end
    end
  end

  def accept
    @post.accept! if current_user.admin?
  end

  def refuse
    @post.refuse! if current_user.admin?
  end

  private
  def find_journal
    @journal = if params[:client_id]
                 Client.find(params[:client_id])
               elsif params[:community_id]
                 Community.find(params[:community_id])
               elsif params[:firm_id]
                 Firm.find(params[:firm_id])
               elsif request.subdomain.present?
                 Firm.find(request.subdomain)
               elsif params[:user_id]
                 User.find(params[:user_id]).profileable
               elsif params[:id]
                 Post.find(params[:id]).journal
               end
    redirect_to root_url unless @journal
  end

  def find_post
    @post = @journal.posts.includes(:images, :videos).find_by_id(params[:id])
    redirect_to journal_page if @post.blank?
  end

  def journal_page
    if @journal.is_a? Community
      community_path(@journal)
    elsif @journal.user.firm?
      firm_posts_page_url(subdomain:  @journal.slug)
    else
      polymorphic_path([@journal, :posts])
    end
  end

  def post_page post
    !@journal.is_a?(Community) && @journal.user.firm ? post_url(post, subdomain: @journal.slug) : polymorphic_path([@journal, post])
  end

  def authorize_moderator
    authorize_or_gtfo :moderate, @journal, polymorphic_path(@journal) unless @journal.is_a?(Community)
  end
end
