#encoding: utf-8
class Admin::BackgroundPropertiesController < ApplicationController
  layout 'admin_application'
  respond_to :html, :js

  def index
    @styles = BackgroundProperty.popular
    if (@type = params[:type]).present?
      @styles = case @type
                  when 'headers' then @styles.headers
                  when 'backgrounds' then @styles.backgrounds
                  else
                end
    end
    @styles = @styles.ordered.page(params[:page])
    respond_with(@styles)
  end

  def show
    redirect_to edit_admin_background_property_path(@style)
  end

  def new
    @style = BackgroundProperty.new(header: params[:type].eql?('headers'))
  end

  def create
    style_params = params[:background_property]
    images = style_params[:image]
    if images.is_a?(Array)
      images.each do |image|
        style_params[:image] = image
        @style = BackgroundProperty.create style_params
      end
    else
      @style = BackgroundProperty.create style_params
    end

    if @style.persisted?
      redirect_to admin_background_properties_path
    else
      render :new
    end
  end

  def edit
    @style = BackgroundProperty.find params[:id]
  end

  def update
    @style = BackgroundProperty.find params[:id]
    if @style.update_attributes params[:background_property]
      redirect_to admin_background_properties_path
    else
      render :edit
    end
  end

  def destroy
    @style = BackgroundProperty.find params[:id]
    @style.destroy

    redirect_to admin_background_properties_url
  end
end
