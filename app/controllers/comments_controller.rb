# encoding: utf-8
class CommentsController < ApplicationController
  before_filter :find_commentable, only: [ :create ]
  before_filter :find_comment, only: [ :show, :update, :destroy ]
  before_filter :authorize_moderator, only: [ :update ]
  before_filter :authorize_destroyer, only: [ :destroy ]

  before_filter only: [ :show, :create, :update ] do
    @parent = params[:parent]
    @parent_id = params[:parent_id]
    @modal = params[:modal] == 'true'
  end

  def create
    @comment_form = CommentForm.new(Comment.build_from(@commentable, current_user.id, @parent_id))

    respond_to do |format|
      if @comment_form.submit(params[:comment])
        format.js {}
        format.json { render json: { images_url: comment_images_path(@comment_form.comment),
                                     comment_url: comment_path(@comment_form.comment, sort_order: params[:sort_order],
                                                                                      parent_id: @parent_id,
                                                                                      parent: @parent,
                                                                                      modal: @modal)} }
      else
        format.js { render js: 'alert("Вы не можете создать сообщение");' }
        format.json { render json: @comment_form.errors, status: :unprocessable_entity }
      end
    end
  end

  def show; end

  def update
    @comment_form = CommentForm.new(@comment)

    respond_to do |format|
      if @comment_form.submit(params[:comment])
        format.js {}
      else
        format.js { render js: 'alert("Вы не можете отредактировать это сообщение");' }
      end
    end
  end

  def destroy
    @comments = @comment.try(:self_and_descendants)
    if @comments
      @removed = @comments.map{ |c| "##{dom_id(c)}" }.join(',')
    else
      @removed = "#comment_#{params[:id]}"
      return
    end

    respond_to do |format|
      if @comment.destroy
        format.js {}
      else
        format.js { render js: 'alert("Вы не можете удалить это сообщение");' }
      end
    end
  end

  private
  def find_commentable
    @commentable = params[:commentable_type].constantize.find(params[:commentable_id])
  end

  def find_comment
    @comment = Comment.find(params[:id])
  end

  def authorize_moderator
    authorize! :moderate, @comment
  end

  def authorize_destroyer
    authorize! :destroy, @comment
  end
end
