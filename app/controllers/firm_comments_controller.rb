# encoding: utf-8
class FirmCommentsController < ApplicationController
  before_filter :find_firm, only: [:create]
  before_filter :find_commentable, only: [:create]
  respond_to :js, :json

  def create
    @comment_form = CommentForm.new(Comment.build_from(@commentable, current_user.id, @parent_id))

    respond_with(@comment) do |format|
      if @comment_form.submit(params[:comment])
        format.html { redirect_to @commentable }
        @comment = @comment_form.comment
        format.json { render json: @comment_form.comment }
        format.js {}
      else
        format.js { render text: "alert('Вы не можете создать сообщение')" }
      end
    end
  end

  def destroy
    @comments = Comment.find_by_id(params[:id]).try(:self_and_descendants)
    return @removed = "#comment_#{params[:id]}" unless @comments

    @removed = @comments.map{ |c| "##{dom_id(c)}" }.join(',')
    respond_with(@comments) do |format|
      if @comments.find(params[:id]).can_moderate?(current_user) &&  @comments.find(params[:id]).destroy
        format.js {}
      else
        format.js { render text: "alert('Вы не можете удалить чужое сообщение')" }
      end
    end
  end

  private
  def find_commentable
    @commentable = params[:commentable_type].constantize.find(params[:commentable_id])

    if params.has_key?(:parent_id)
      @parent = Comment.find(params[:parent_id])
      @parent_id = @parent.id
      @level = @parent.level + 1
    else
      @parent_id = nil
      @level = 0
    end
  end

  def find_firm
    @firm = Firm.find(request.subdomain)
  end
end
