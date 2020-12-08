# encoding: utf-8
class VideosController < ApplicationController
  respond_to :js, :html

  skip_before_filter :authenticate_user!, only: :show
  before_filter :find_owner, except: [ :accept, :refuse ]
  before_filter :find_video, only: [ :show, :destroy, :edit, :update ]
  before_filter :authorize_moderator, only: [ :new, :create, :destroy, :edit, :update ]
  before_filter :change_status, only: [:create, :update]

  def index
    @videos = @owner.videos.page(params[:page])

    respond_to do |format|
      format.html {}
      format.js { render json: json_video(@videos) }
    end
  end

  def new
    @video = @owner.videos.new

    respond_with(@video) do |format|
      format.html do
        session[:new] = true
        redirect_to owner_page
      end
      format.js {}
    end
  end

  def create
    if params[:video][:content].match(/vk/) || params[:video][:content].match(/vimeo/)
      @video_service = VideoService::Base.new(current_user, params[:video])

      @video = init_video_with_owner

      @video.media_preview = @video_service.preview_image
      @video.content = @video_service.player
      @video.duration = @video_service.duration
    else
      @video = init_video_with_owner
    end

    respond_to do |format|
      if @video.save
        format.html { redirect_to video_page }
      else
        Rails.logger.info(@video.errors.full_messages)
        format.html { redirect_to owner_page }
      end
    end
  end

  def show
    @video.increment! :views
    @comments = @video.comment_threads.includes(:user, :commentable).reorder('updated_at DESC')
    @video_page = if request.subdomain.present?
                    @video.multimedia.firm ? video_url(@video, subdomain: @video.multimedia.firm.slug) : polymorphic_path([@owner, @video])
                  elsif request.url.include?('admin')
                    polymorphic_path([:admin, @owner, @video])
                  else
                    polymorphic_path([@owner, @video])
                  end
    respond_to do |format|
      format.html do
        session[:video] = video_page
        redirect_to owner_page
      end
      format.js {}
    end
  end

  def destroy
    @video.destroy
    redirect_to owner_page
  end

  def all
    @videos = MediaContent.videos
    @videos = @videos.tagged_with(params[:tags].split(',')) if params[:tags]
  end

  def edit
    if @video.content.match(/vk/) || @video.content.match(/vimeo/)
      video_service = VideoService::Base.new(current_user, {content: @video.content})
      @video_link = video_service.original_link 
    end
  end

  def update
    if params[:video][:content].match(/vk/) || params[:video][:content].match(/vimeo/)
      @video_service = VideoService::Base.new(current_user, params[:video])

      @video.media_preview = @video_service.preview_image
      @video.duration = @video_service.duration
      params[:video].merge!({content: @video_service.player})
    end

    respond_to do |format|
      if @video.update_attributes(params[:video])
        format.html { redirect_to video_page }
      else
        format.html { redirect_to owner_page }
      end
    end
  end

  def accept
    @video = MediaContent.videos.find(params[:id])
    @video.accept! if current_user.admin?
  end

  def refuse
    @video = MediaContent.videos.find(params[:id])
    @video.refuse! if current_user.admin?
  end

  private
  def init_video_with_owner
    video = @owner.videos.new(params[:video])
    video.video = true

    video
  end

  def change_status
    params[:video][:status] = params[:video][:status] ? 1 : 0
  end

  def find_owner
    @owner = if params[:client_id]
               Client.find(params[:client_id])
             elsif params[:community_id]
               Community.find(params[:community_id])
             elsif params[:user_id]
               User.find(params[:user_id]).profileable
             elsif params[:firm_id]
               Firm.find(params[:firm_id])
             elsif request.subdomain.present?
               Firm.find(request.subdomain)
             end
    redirect_to root_url unless @owner
  end

  def find_video
    @video = @owner.videos.find_by_id(params[:id])
    redirect_to owner_page if @video.blank?
  end

  def owner_page
    @owner.user.firm ? firm_videos_url(subdomain: @owner.slug) : polymorphic_path([@owner, :videos])
  end

  def video_page
    @owner.user.firm ? video_url(@video, subdomain:  @owner.slug) : polymorphic_path([@owner, @video])
  end

  def authorize_moderator
    authorize_or_gtfo :moderate, @owner, polymorphic_path(@owner)
  end

  # todo: consolidate with json_images ?
  def json_video(videos)
    json_videos = []
    videos.each do |video|
      youtube_id = /(?:&|\?)v=([^&]+)/.match(video.content)[1]
      json_videos << {
        youtube_id: youtube_id,
        thumb: "http://img.youtube.com/vi/#{youtube_id}/0.jpg",
        image: "http://img.youtube.com/vi/#{youtube_id}/0.jpg",
        title: video.title
      }
    end
    json_videos
  end
end
