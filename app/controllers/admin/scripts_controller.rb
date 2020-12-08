# encoding: utf-8
class Admin::ScriptsController < AdminController
  layout 'admin_application'
  before_filter :find_script, only: [:edit, :update, :destroy]

  def index
    @scripts = Script.all
  end

  def new
    @script = Script.new
  end

  def edit
    render :new
  end

  def create
    @script = Script.new(params[:script])
    if @script.save
      redirect_to admin_scripts_path, notice: 'Сценарий успешно создан'
    else
      render :new
    end
  end

  def update
    if @script.update_attributes(params[:script])
      redirect_to admin_scripts_path, notice: 'Сценарий успешно обновлён'
    else
      render :edit
    end
  end

  def destroy
    @script.destroy
    redirect_to admin_scripts_path, notice: 'Сценарий успешно удалён'
  end

  private
    def find_script
      @script = Script.find(params[:id])
    end
end
