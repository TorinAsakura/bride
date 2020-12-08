# encoding: utf-8
class ComplaintsController < ApplicationController
  before_filter :find_pretension
  respond_to :js, :json

  def new
    @complaint = @pretension.complaints.new
    respond_with(@complaint) do |format|
      @count = @pretension.complaints.where(:user_id => current_user.id).count
      format.js {render :layout => false}
    end
  end

  def create
    @complaint = @pretension.complaints.new(params[:complaint])
    @complaint.user = current_user

    respond_with(@complaint) do |format|
      if @complaint.save
        format.js { render :js => "alert('Спасибо за Ваше обращение!');$('#edit .modal').modal('hide');" }
      else
        format.js { render :js => "alert('Ошибка')" }
      end
    end
  end

  private
  def find_pretension
    @klass      = params[:resource_type].constantize
    @pretension = @klass.find(params[:resource_id])
  end

end
