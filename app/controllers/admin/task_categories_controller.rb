# encoding: utf-8
class Admin::TaskCategoriesController < AdminController
  layout 'admin_application'
  before_filter :find_task_category, only: [:show, :edit, :update, :destroy]

  def index 
    if params[:category_id]
      @task_category = TaskCategory.find(params[:category_id])
      @tasks = TaskDecorator.decorate_collection(@task_category.tasks)
    end
    @task_categories = TaskCategory.all
  end

  def show
    @tasks = TaskDecorator.decorate_collection(@task_category.tasks)
  end

  def new
    @task_category = TaskCategory.new
  end

  def edit
    render :new
  end

  def create
    @task_category = TaskCategory.new(params[:task_category])
    if @task_category.save
      redirect_to admin_task_categories_path, notice: 'Категория успешно создана'
    else
      render :new
    end
  end

  def update
    if @task_category.update_attributes(params[:task_category])
      redirect_to admin_task_categories_path, notice: 'Категория успешно обновлена'
    else
      render :new
    end
  end

  def destroy
    if @task_category.tasks.any?
      flash[:notice] = 'Можно удалить только пустую категорию'
    else
      @task_category.destroy
      flash[:notice] = 'Категория успешно удалена'
    end
    redirect_to admin_task_categories_path
  end

  private
  def find_task_category
    @task_category = TaskCategory.find(params[:id])
  end
end
