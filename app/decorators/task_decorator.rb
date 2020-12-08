class TaskDecorator < Draper::Decorator
  delegate_all

  def type_id
    case type_task.to_s
    when Event::SIMPLY then 2
    when Event::WITH_SERVICE then 3
    when Event::ADVICE then 4
    else 0
    end
  end
end

