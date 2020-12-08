# encoding: utf-8
class Admin::ComplaintsController < AdminController
  layout 'admin_application'

  respond_to :js, :json

  def index
    params[:type] = 'MediaContent' if params[:type] == 'Video' || params[:type] == 'Audio'

    search = { :pretension_type => params[:type] }
    search = {} unless params[:type]

    @complaints = Complaint.where(search).page(params[:page])
  end

  def show
    @complaint = Complaint.find(params[:id])
  end

  def destroy
    @complaint = Complaint.find(params[:id])
    @complaint.destroy
    redirect_to :action => :index
  end
end
