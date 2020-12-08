# encoding: utf-8
class PromisesController < ApplicationController
  before_filter :find_resources
  respond_to :js

  def create
    @promise = Promise.new(params[:promise])
    @promise.user = @user
    @promise.wishlist = @wishlist
    respond_with(@promise) do |format|
      if @promise.save
        format.js {render :js => "window.location.reload();"}
      else
        format.js { render :js => "alert('Ошибка')" }
      end
    end
  end

  def destroy
    @promise = current_user.promises.find(params[:id])
    respond_with(@promise) do |format|
      if @promise.destroy
        format.js { render :js => "window.location.reload();"}
      else
        format.js { render :js => "alert('Что-то пошло не так')" }
      end
    end
  end

  private
  def find_resources
    @user = current_user
    @wishlist = Wishlist.find(params[:wishlist_id])
  end
end
