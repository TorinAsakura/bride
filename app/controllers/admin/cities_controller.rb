# encoding: utf-8
class Admin::CitiesController < AdminController
  layout 'admin_application'

  def index
    @cities = City.filtered_cities(params[:search]).page(params[:page]).order('cities.name DESC')
  end

  def new
    @city = City.new
  end

  def edit
    @city = City.find params[:id]
    render :new
  end

  def create
    @city = City.new(params[:city])
    if @city.save
      redirect_to admin_cities_path, notice: 'Город успешно добавлен'
    else
      render :new
    end
  end

  def update
    @city = City.find params[:id]
    if @city.update_attributes(params[:city])
      redirect_to admin_cities_path, notice: 'Город успешно обновлён'
    else
      render :edit
    end
  end

  def destroy
    @city.destroy
    redirect_to admin_cities_path, notice: 'Город успешно удалён'
  end
end
