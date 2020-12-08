# encoding: utf-8
class InterestingController < ApplicationController
  skip_before_filter :authenticate_user!
  before_filter :find_posts, except: :videos
  before_filter :find_videos

  def show; end

  def videos; end

  private
  def sort_column
    (['created_at', 'cached_votes_up', 'views'].include? params[:sort_column]) ? params[:sort_column] : 'created_at'
  end

  def sort_direction
    (['asc', 'desc'].include? params[:sort_direction]) ? params[:sort_direction] : 'desc'
  end

  def find_posts
    if params[:posts_search]
      @posts = Post.accepted.search(params[:posts_search])
    else
      @posts = Post.includes(:journal, :illustration).accepted
      @posts = @posts.tagged_with(params[:tags].split(',')) if params[:tags]
    end
    @posts = @posts.reorder("#{sort_column} #{sort_direction}").page(params[:page])
  end

  def find_videos
    if params[:videos_search]
      @videos = MediaContent.videos.accepted.search(params[:videos_search])
    else
      @videos = MediaContent.videos.accepted
      @videos = @videos.tagged_with(params[:tags].split(',')) if params[:tags]
    end
    @videos = @videos.reorder("#{sort_column} #{sort_direction}").page(params[:page])
  end
end
