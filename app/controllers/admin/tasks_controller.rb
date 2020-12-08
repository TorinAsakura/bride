# encoding: utf-8
class Admin::TasksController < AdminController
  before_filter :find_task, except: [:new, :create, :get_firm_catalog_children]

  def new
    task_category = TaskCategory.find(params[:id])
    @task = task_category.tasks.new
  end

  def edit
    @idea_categories_group = @task.idea_category_tasks.includes(:category,:section).group_by(&:section_id)
    @firm_catalogs = @task.firm_catalogs
    render :new
  end

  def create
    @task = Task.new(params[:task])
    if @task.save
      render json: { status: 'success', id: @task.id, task_category_id: params[:task][:task_category_id] }
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def update
    @task.idea_categories.destroy_all
    @task.firm_catalogs.destroy_all
    if @task.update_attributes(params[:task])
      render json: { status: 'success', id: @task.id, task_category_id: params[:task][:task_category_id] }
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @task.destroy
    redirect_to admin_task_categories_path(category_id: params[:category_id])
  end

  def get_firm_catalog_children
    render json: FirmCatalog.select('id, name').where('parent_id = ?', params[:id])
  end

  def load_file
    file  = params[:file][:files].last
    title = params[:file][:title].last
    status = if is_image? file
               @task.images.create(image: file) ? 'ok' : 'error'
             elsif is_file? file
               @task.files.create(url: file, title: title ) ? 'ok' : 'error'
             end
    render json: status
  end
  
  def load_image
  end

  def remove_file
    render json: true if @task.files.find(params[:file_id]).destroy
  end

  def remove_image
    render json: true if @task.images.find(params[:image_id]).destroy
  end

  def update_all_events
    @task.events.each { |e| e.update_attributes(name: @task.name, description: @task.description) }
    redirect_to admin_task_categories_path(category_id: @task.task_category_id, task_id: @task.id), 
                notice: 'Задача успешно обновлена для всех планировщиков'
  end

  private
  def find_task
    @task = Task.find(params[:id])
  end


  def is_image? load_file
    File.extname(load_file.original_filename).downcase =~ /jpg|png|bmp|gif/
  end

  def is_file? load_file
    File.extname(load_file.original_filename).downcase =~ /docx|doc|pdf|xls|rar/
  end
end
