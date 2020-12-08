# encoding: utf-8
class Admin::VideosController < AdminController
  layout 'admin_application'

  respond_to :js, :html

  before_filter :find_video, except: :index

  def index
    @videos = MediaContent.videos.includes(multimedia: :profileable).where(params.slice :status).reorder('id DESC').page(params[:page])
  end

  private
  def find_video
    @video = MediaContent.videos.find(params[:id])
  end
end
