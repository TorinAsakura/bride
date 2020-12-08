# encoding: utf-8
class FirmPagesController < ApplicationController
  before_filter :find_firm
  before_filter :find_firm_page, only: [:update, :destroy, :switch]
  before_filter :authorize_moderator

  def create
    @firm_page = @firm.firm_pages.new
    firm_page_form = FirmPageForm.new(@firm_page, @firm)

    respond_to do |format|
      if firm_page_form.submit()
        format.html { redirect_to edit_firm_path(@firm, anchor: @firm_page.anchor) }
      else
        format.html { render :new }
      end
    end
  end

  def update
    firm_page_form = FirmPageForm.new(@firm_page, @firm)

    respond_to do |format|
      if firm_page_form.submit(params[:firm_page])
        format.json { render json: { images_url: firm_firm_page_images_path(@firm, @firm_page),
                                     firm_page_url: edit_firm_path(@firm, anchor: @firm_page.anchor) } }
      else
        format.json
      end
    end
  end

  def destroy
    @firm_page.destroy
    redirect_to edit_firm_path(@firm)
  end

  def change_rating
    params[:ids].each_with_index do |id, index|
      current_firm.firm_pages.find(id).update_attribute(:rating, index.to_i+1)
    end
    render nothing: true
  end

  def switch
    @firm_page.update_attribute(:shown, !@firm_page.shown)
  end

  private
  def find_firm
    @firm = Firm.find(params[:firm_id])
  end

  def find_firm_page
    @firm_page = FirmPage.find(params[:id])
  end

  def authorize_moderator
    authorize_or_gtfo :moderate, @firm, root_path
  end
end
