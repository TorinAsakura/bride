# encoding: utf-8
class PollsController < ApplicationController
  respond_to :js, :html

  skip_before_filter :authenticate_user!, only: [:index, :show]
  before_filter :find_poll, only: [ :show, :destroy ]
  before_filter :authorize_moderator, only: [ :destroy ]

  #NOTE need best refactoring
  before_filter :tmp_images_present_new, only: :new
  before_filter :tmp_images_present_create, only: :create
  after_filter :delete_tmp_poll_images, only: :create

  def index
    @polls = Poll.page(params[:page])
  end

  def new
    @polls = Poll.page(params[:page])
    @poll = Poll.new

    if @tmp_poll_images_ids
      @poll_tmp_images = PollTmpImage.find(@tmp_poll_images_ids)
    else
      @poll.images.build
    end

    respond_with(@poll) do |format|
      format.js
      format.html do
        session[:new_poll] = true
        redirect_to polls_path
      end
    end
  end

  def create
    @poll = Poll.new(params[:poll])

    if @tmp_poll_images_ids
      @tmp_poll_images_ids.each do |id|
        poll_image = PollImage.new
        poll_image.remote_image_url = PollTmpImage.find(id).image.url
        @poll.images << poll_image
      end
    end

    @poll.client = current_client

    respond_to do |format|
      if @poll.save
        format.js { render js: "window.location = '#{polls_path}'" }
        format.html { redirect_to polls_path }
      else
        format.js { render nothing: true }
        format.html { redirect_to polls_path, notice: @poll.errors.each{|e| e} }
      end
    end
  end

  def show
    @comments = @poll.comment_threads.includes(:user, :commentable).reorder('updated_at DESC')

    respond_to do |format|
      format.js { render layout: false }
      format.html do
        session[:poll] = poll_path(@poll)
        redirect_to polls_path
      end
    end
  end

  def destroy
    @poll.destroy

    redirect_to polls_path
  end

  private
  def find_poll
    @poll = Poll.find(params[:id])
  end

  def tmp_images_present_new
    @tmp_poll_images_ids = if params[:tmp_poll_images_ids]
       eval(params[:tmp_poll_images_ids])
    end
  end

  def tmp_images_present_create
    @tmp_poll_images_ids = if params[:poll][:tmp_poll_images_ids]
       eval(params[:poll][:tmp_poll_images_ids])
    end
  end

  def authorize_moderator
    authorize_or_gtfo :moderator, @poll, polls_path
  end

  def delete_tmp_poll_images
    PollTmpImage.destroy(@tmp_poll_images_ids) if @tmp_poll_images_ids
  end
end
