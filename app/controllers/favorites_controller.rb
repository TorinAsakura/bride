# encoding: utf-8
class FavoritesController < ApplicationController
  before_filter :find_resource, :except => :index
  respond_to :js, :json

  def index
    @favorites = Favorite.where(:user_id => current_user.id).page params[:page]
  end

  def create
    @favorite = @favoriteable.favorites.new(params[:favorite])
    @favorite.user = current_user
    respond_with(@favorite) do |format|
      if @favorite.save
        format.html {redirect_to @favorite}
        format.js {}
      else
        format.js { render :js => "alert('Ошибка')" }
      end
    end
  end

  def destroy
    @favorite = Favorite.find(params[:id])
    respond_with(@favorite) do |format|
      if @favorite.user.id == current_user.id && @favorite.destroy
        format.js {}
      else
        format.js { render :js => "alert('Что-то пошло не так')" }
      end
    end
  end

  private

  def find_resource
    @klass        = params[:resource_type].constantize
    @favoriteable = @klass.find(params[:resource_id])
  end

end
