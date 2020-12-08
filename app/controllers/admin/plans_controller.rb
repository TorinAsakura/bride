# encoding: utf-8
class Admin::PlansController < AdminController
  before_filter :find_plan, except: [:edit]

  def edit
    plans = Plan.where(script_id: params[:script_id])

    @planning = plans.week.planning.first
    @weeks = plans.week.reverse
    @days = plans.day.reverse
    @wedding_day = plans.wedding_day.first
    @after_wedding = plans.after_wedding.first

    @plan = plans.find(params[:id])
    plan_task = @plan.tasks.includes(:task_category, :task_positions).order('task_positions.position')
    plan_free_task = Task.all - plan_task - @plan.script.tasks
    @plan_task = TaskDecorator.decorate_collection(plan_task)
    @plan_free_task = TaskDecorator.decorate_collection(plan_free_task)
    @category = TaskCategory.includes(:tasks)
  end

  def update
    if @plan.update_attributes(params[:plan])
      redirect_to admin_scripts_path, notice: 'Настройка успешно завершена'
    else
      render :edit
    end
  end
  
  def add_task
    task = Task.find(params[:task_id])
    @plan.tasks << task
    render json: { status: 'ok', task_id: task.id }
  end

  def remove_task
    task = @plan.tasks.find(params[:task_id])
    task_position = @plan.task_positions.find_by_task_id(task.id)
    task_position.destroy if task_position.present?
    @plan.tasks.delete(task)
    render json: { status: 'ok', task_id: task.id }
  end

  def order_tasks
    params[:ids].try(:each_with_index) do |id, index|
      task_position = @plan.task_positions.find_or_initialize_by_task_id(id)
      task_position.position = index.to_i + 1
      task_position.save
    end
    render nothing: true
  end

  private
  def find_plan
    @plan = Plan.find(params[:id])  
  end
end
