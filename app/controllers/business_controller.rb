# encoding: utf-8
class BusinessController < ApplicationController
  before_filter :find_firm
  before_filter :check_destroy_ability

  def destroy
    @firm.business.destroy if @firm.business
    redirect_to edit_firm_path(@firm), :notice => 'Форма собственности удалена'
  end

  private
  def find_firm
    @firm = Firm.find(params[:firm_id])
    redirect_to firms_path, :alert => 'Фирма не найдена' unless @firm
  end

  def check_destroy_ability
    redirect_to firms_path, :alert => 'Не достаточно прав для редактирования' unless @firm.can_edit?(current_user)
  end

  # todo: move flash messages to locales

end
