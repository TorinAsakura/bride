# encoding: utf-8
class Admin::FirmsController < AdminController
  layout 'admin_application'
  respond_to :js, :html

  before_filter :find_resource, only: [:edit, :update, :destroy, :dealer]

  def index
    @firms = Firm.with_deleted.filtered(params[:search]).page(params[:page])
    @firms = @firms.ordered
    if (type = params[:type]).present?
      case type
        when 'dealers'
          @firms = @firms.dealers
        else
      end
    end
    respond_with(@firms)
  end

  def edit
    respond_with(@firm)
  end

  def update
    params[:firm].delete('status') if @firm.status != (new_status = params[:firm][:status])
    respond_to do |format|
      if @firm.update_attributes(params[:firm])
        @firm.banner_album.update_for_banner_album(params[:banner_album])
        @firm.change_status(new_status) unless params[:firm][:status]
        format.html { redirect_to edit_admin_firm_path(@firm), notice: 'Фирма успешно изменена' }
        format.json { head(:no_content) }
      else
        format.html { render :edit }
        format.json { render json: @firm.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @firm.deleted? ? @firm.recover : @firm.destroy
    respond_with(@firm)
  end

  def dealer
    if @firm.dealer?
      unless @firm.has_children_firms?
        @firm.user.remove_role(:dealer)
        @firm.purse.send(:discount_by_firm!)
      end
    else
      @firm.user.add_role(:dealer)
      @firm.purse.send(:discount_by_dealer!)
    end
    respond_with(@firm) do |format|
      format.html{ redirect_to admin_firms_path}
    end
  end

  private
  def find_resource
    @firm = Firm.with_deleted.find(params[:id])
  end
end
