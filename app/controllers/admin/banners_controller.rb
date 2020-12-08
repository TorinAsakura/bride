#encoding: utf-8
class Admin::BannersController < ApplicationController
  layout 'admin_application'
  before_filter :find_banner, only: [:edit, :update, :destroy]

  def index
    @banners = Banner.reorder('id DESC').all
  end

  def new
    @banner = Banner.new
  end

  def create
    @banner = Banner.new(params[:banner])
    if @banner.save
      redirect_to admin_banners_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @banner.update_attributes(params[:banner])
      redirect_to admin_banners_path
    else
      render :edit
    end
  end

  def destroy
    @banner.destroy
    redirect_to admin_banners_path
  end

  private
  def find_banner
    @banner = Banner.find(params[:id])
  end
end
