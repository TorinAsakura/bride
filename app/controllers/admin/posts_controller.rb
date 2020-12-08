# encoding: utf-8
class Admin::PostsController < AdminController
  layout 'admin_application'
  skip_before_filter  :verify_authenticity_token, only: [:accept, :refuse]

  respond_to :js, :html

  before_filter :find_post, except: :index

  def index
    @posts = Post.where(params.slice :status).without_communities.reorder('id DESC').page(params[:page])
  end

  private
  def find_post
    @post = Post.find(params[:id])
  end
end
