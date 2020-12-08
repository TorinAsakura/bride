# encoding: utf-8
class AttachmentImagesController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:show]
  before_filter :find_resource
  before_filter :find_image, except: :create

  def create
    @image = @resource.images.new(image: params[:image])
    @modal = params[:modal] == 'true'

    respond_to do |format|
      if @image.save
        format.js { head :ok }
      else
        format.js { render js: 'alert("Вы не можете прикрепить изображение");' }
      end
    end
  end

  def show
    render "#{@resource.class.name.downcase}_images/show"
  end

  def destroy
    @removed = dom_id(@image)
    @image.destroy

    render "#{@resource.class.name.downcase}_images/destroy"
  end

  private
  def find_resource
    @resource = if params[:community_id].present?
                  Community.find(params[:community_id])
                elsif params[:post_id].present?
                  Post.find(params[:post_id])
                elsif params[:comment_id].present?
                  Comment.find(params[:comment_id])
                elsif params[:firm_page_id].present?
                  FirmPage.find(params[:firm_page_id])
                elsif params[:task_id].present?
                  Task.find(params[:task_id])
                elsif params[:message_id].present?
                  Message.find(params[:message_id])
                end
  end

  def find_image
    @image = @resource.images.find(params[:id])
  end
end
